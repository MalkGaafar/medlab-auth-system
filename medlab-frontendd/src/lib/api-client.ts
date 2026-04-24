// ============================================================
// MedLab API Client - FIXED (fully aligned with backend)
// ============================================================

const BASE_URL =
  (import.meta.env.VITE_API_BASE_URL as string) ||
  "http://localhost:5000/api";

const TOKEN_KEY = "medlab_token";

// ============================================================
// TYPES
// ============================================================

export type Role = "Admin" | "Doctor" | "Specialist" | "Patient";

export type Permission =
  | "users:read"
  | "users:delete"
  | "users:manage_roles"
  | "users:approve"
  | "reports:read_own"
  | "reports:read_all"
  | "reports:create"
  | "reports:delete"
  | "reports:assign_self"
  | "reports:update_verdict"
  | "patients:read_all"
  | "labtests:read"
  | "labtests:manage";

export interface AuthUser {
  id: string;
  email: string;
  name: string;
  roles: Role[];
  permissions: Permission[];
  isApproved: boolean;
}

export interface LabTest {
  id: number;
  testName: string;
  description: string;
  normalRange: string;
  createdAt: string;
}

export interface ClinicalReport {
  id: number;
  labTestId: number;
  labTestName: string;
  normalRange: string;
  patientId: string;
  patientName: string;
  createdByUserId: string;
  createdByName: string;
  assignedDoctorId: string | null;
  assignedDoctorName: string | null;
  result: string;
  findings: string;
  notes: string;
  finalVerdict: string | null;
  urgencyLevel: number;
  reportDate: string;
  verdictGivenAt: string | null;
}

export interface PendingUser {
  id: string;
  email: string;
  name: string;
  requestedRole: Role;
  createdAt: string;
}

export interface AdminUser extends AuthUser {
  createdAt: string;
}

// ============================================================
// ERROR
// ============================================================

class ApiError extends Error {
  status: number;
  constructor(message: string, status: number) {
    super(message);
    this.status = status;
  }
}

// ============================================================
// TOKEN
// ============================================================

function getToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem(TOKEN_KEY);
}

export function setToken(token: string | null) {
  if (typeof window === "undefined") return;
  if (token) localStorage.setItem(TOKEN_KEY, token);
  else localStorage.removeItem(TOKEN_KEY);
}

// ============================================================
// CORE REQUEST
// ============================================================

async function request<T>(
  path: string,
  options: RequestInit = {}
): Promise<T> {
  const token = getToken();

  const headers: Record<string, string> = {
    "Content-Type": "application/json",
    ...((options.headers as Record<string, string>) || {}),
  };

  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers,
  });

  if (res.status === 204) return undefined as T;

  const text = await res.text();
  const data = text ? JSON.parse(text) : null;

  if (!res.ok) {
    if (res.status === 401) setToken(null);

    const msg =
      (data && (data.message || data.error || data.title)) ||
      `Request failed (${res.status})`;

    throw new ApiError(msg, res.status);
  }

  return data as T;
}

// ============================================================
// AUTH
// ============================================================

export const authApi = {
  login: (email: string, password: string) =>
    request<{ token: string; user: AuthUser }>("/auth/login", {
      method: "POST",
      body: JSON.stringify({ email, password }),
    }),

  register: (
    email: string,
    password: string,
    name: string,
    role: Role
  ) =>
    request<{ message: string; pendingApproval: boolean }>(
      "/auth/register",
      {
        method: "POST",
        body: JSON.stringify({
          email,
          password,
          userName: name,
          role,
        }),
      }
    ),

  me: () => request<AuthUser>("/auth/me"),

  logout: () =>
    request<void>("/auth/logout", {
      method: "POST",
    }),
};

// ============================================================
// LAB TESTS
// ============================================================

export const labTestsApi = {
  list: () => request<LabTest[]>("/labtests"),

  create: (data: {
    testName: string;
    description: string;
    normalRange: string;
  }) =>
    request<LabTest>("/labtests", {
      method: "POST",
      body: JSON.stringify(data),
    }),
};

// ============================================================
// REPORTS (FIXED EXACTLY TO BACKEND)
// ============================================================

export const reportsApi = {
  list: () => request<ClinicalReport[]>("/reports"),

  create: (data: {
    patientId: string;
    labTestId: number;
    result: string;
    findings: string;
    urgencyLevel: number;
  }) =>
    request<ClinicalReport>("/reports", {
      method: "POST",
      body: JSON.stringify(data),
    }),

  // DOCTOR CLAIM REPORT
  claim: (reportId: number) =>
    request<ClinicalReport>(`/reports/${reportId}/assign`, {
      method: "POST",
    }),

  // DOCTOR SUBMIT FINAL VERDICT
  setVerdict: (
    reportId: number,
    finalVerdict: string,
    notes: string
  ) =>
    request<ClinicalReport>(`/reports/${reportId}/verdict`, {
      method: "PATCH",
      body: JSON.stringify({ finalVerdict, notes }),
    }),
};

// ============================================================
// PATIENTS
// ============================================================

export const patientsApi = {
  list: () =>
    request<{ id: string; name: string; email: string }[]>("/patients"),
};

// ============================================================
// ADMIN
// ============================================================

export const adminApi = {
  pendingUsers: () =>
    request<PendingUser[]>("/admin/users/pending"),

  approve: (userId: string) =>
    request<void>(`/admin/users/${userId}/approval`, {
      method: "POST",
      body: JSON.stringify({ approve: true }),
    }),

  reject: (userId: string) =>
    request<void>(`/admin/users/${userId}/approval`, {
      method: "POST",
      body: JSON.stringify({ approve: false }),
    }),

  listUsers: () => request<AdminUser[]>("/admin/users"),

  deleteUser: (userId: string) =>
    request<void>(`/admin/users/${userId}`, {
      method: "DELETE",
    }),
};