import { createContext, useContext, useState, useCallback, useEffect, type ReactNode } from "react";
import { authApi, setToken as saveToken, type AuthUser, type Role, type Permission } from "./api-client";

interface AuthContextType {
  user: AuthUser | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  register: (
    email: string,
    password: string,
    name: string,
    role: Role
  ) => Promise<{ success: boolean; error?: string; requiresApproval?: boolean }>;
  logout: () => Promise<void>;
  hasPermission: (perm: Permission) => boolean;
  hasRole: (role: Role) => boolean;
  refresh: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const refresh = useCallback(async () => {
    try {
      const me = await authApi.me();
      setUser(me);
    } catch {
      saveToken(null);
      setUser(null);
    }
  }, []);

  useEffect(() => {
    const token = typeof window !== "undefined" ? localStorage.getItem("medlab_token") : null;
    if (token) {
      refresh().finally(() => setIsLoading(false));
    } else {
      setIsLoading(false);
    }
  }, [refresh]);

const login = useCallback(async (email: string, password: string) => {
  try {
    const res = await authApi.login(email, password);

    if (!res.token) {
      return {
        success: false,
        error: "Account pending approval or invalid login",
      };
    }

    saveToken(res.token);
    await refresh();

    return { success: true };
  } catch (e) {
    return {
      success: false,
      error: e instanceof Error ? e.message : "Login failed",
    };
  }
}, [refresh]);

const register = useCallback(
  async (email: string, password: string, name: string, role: Role) => {
    try {
      const res = await authApi.register(email, password, name, role);

      return {
        success: true,
        requiresApproval: res.pendingApproval, // 🔥 FIX HERE
      };
    } catch (e) {
      return {
        success: false,
        error: e instanceof Error ? e.message : "Registration failed",
      };
    }
  },
  []
);

  const logout = useCallback(async () => {
    try {
      await authApi.logout();
    } catch {
      /* ignore */
    }
    saveToken(null);
    setUser(null);
  }, []);

  const hasPermission = useCallback(
    (perm: Permission) => user?.permissions?.includes(perm) || false,
    [user]
  );

  const hasRole = useCallback((role: Role) => user?.roles?.includes(role) || false, [user]);

  return (
    <AuthContext.Provider
      value={{ user, isLoading, login, register, logout, hasPermission, hasRole, refresh }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
