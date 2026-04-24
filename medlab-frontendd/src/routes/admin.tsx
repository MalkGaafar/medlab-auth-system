import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useAuth } from "../lib/auth-context";
import { Navbar } from "../components/Navbar";
import { adminApi, type AdminUser } from "../lib/api-client";
import { Trash2, Users, Shield, Stethoscope, FlaskConical, UserRound, AlertCircle } from "lucide-react";

export const Route = createFileRoute("/admin")({
  component: AdminPage,
});

const ROLE_ICONS: Record<string, React.ReactNode> = {
  Admin: <Shield className="w-3.5 h-3.5" />,
  Doctor: <Stethoscope className="w-3.5 h-3.5" />,
  Specialist: <FlaskConical className="w-3.5 h-3.5" />,
  Patient: <UserRound className="w-3.5 h-3.5" />,
};

const ROLE_COLORS: Record<string, string> = {
  Admin: "bg-destructive/10 text-destructive",
  Doctor: "bg-info/10 text-info",
  Specialist: "bg-primary/10 text-primary",
  Patient: "bg-success/10 text-success",
};

function AdminPage() {
  const { user, isLoading, hasRole } = useAuth();
  const navigate = useNavigate();
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!isLoading && (!user || !hasRole("Admin"))) navigate({ to: "/dashboard" });
  }, [user, isLoading, hasRole, navigate]);

  const load = async () => {
    try {
      const u = await adminApi.listUsers();
      setUsers(u);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { if (user) load(); }, [user]);

  const handleDelete = async (id: string, name: string) => {
    if (!confirm(`Delete user "${name}"? This cannot be undone.`)) return;
    setBusy(id);
    setError("");
    try {
      await adminApi.deleteUser(id);
      await load();
    } catch (e: any) {
      setError(e instanceof Error ? e.message : "Failed to delete user. They may have active records in the system.");
    } finally {
      setBusy(null);
    }
  };

  if (isLoading || !user) return null;

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="w-10 h-10 rounded-lg bg-gradient-primary flex items-center justify-center text-primary-foreground">
            <Users className="w-5 h-5" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-foreground">User Management</h1>
            <p className="text-sm text-muted-foreground">All approved users on the platform</p>
          </div>
        </div>

        {error && (
          <div className="mb-4 flex items-start gap-2 p-3 rounded-lg bg-destructive/10 text-destructive text-sm animate-in fade-in slide-in-from-top-1">
            <AlertCircle className="w-4 h-4 mt-0.5 flex-shrink-0" />
            <span>{error}</span>
          </div>
        )}

        <div className="mt-6 rounded-xl border border-border bg-card overflow-hidden shadow-soft">
          {loading ? (
            <div className="text-center py-16 text-muted-foreground">Loading users...</div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-muted/40 border-b border-border">
                  <tr>
                    <th className="text-left px-5 py-3 font-medium text-muted-foreground">User</th>
                    <th className="text-left px-5 py-3 font-medium text-muted-foreground">Role</th>
                    <th className="text-left px-5 py-3 font-medium text-muted-foreground">Status</th>
                    <th className="text-left px-5 py-3 font-medium text-muted-foreground">Joined</th>
                    <th className="text-right px-5 py-3 font-medium text-muted-foreground">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {users.map((u) => (
                    <tr key={u.id} className="border-b border-border last:border-0 hover:bg-muted/20">
                      <td className="px-5 py-3">
                         <p className="font-medium">{u.name}</p>                       
                        <p className="text-xs text-muted-foreground">{u.email}</p>
                      </td>
                      <td className="px-5 py-3">
                        <span className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-xs font-semibold ${ROLE_COLORS[u.roles[0]] || "bg-muted"}`}>
                          {ROLE_ICONS[u.roles[0]]} {u.roles[0]}
                        </span>
                      </td>
                      <td className="px-5 py-3">
                        {u.isApproved ? (
                          <span className="text-success text-xs">● Active</span>
                        ) : (
                          <span className="text-warning-foreground text-xs">● Pending</span>
                        )}
                      </td>
                      <td className="px-5 py-3 text-muted-foreground">
                        {new Date(u.createdAt).toLocaleDateString()}
                      </td>
                      <td className="px-5 py-3 text-right">
                        {u.id !== user.id && (
                          <button
                            onClick={() => handleDelete(u.id, u.name)}
                            disabled={busy === u.id}
                            className="inline-flex items-center gap-1 px-2.5 py-1 rounded-md bg-destructive/10 text-destructive hover:bg-destructive/20 text-xs disabled:opacity-50"
                          >
                            <Trash2 className="w-3.5 h-3.5" /> Delete
                          </button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
