import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useAuth } from "../lib/auth-context";
import { Navbar } from "../components/Navbar";
import { adminApi, type PendingUser } from "../lib/api-client";
import { Check, X, ClipboardCheck, Stethoscope, FlaskConical } from "lucide-react";

export const Route = createFileRoute("/approvals")({
  component: ApprovalsPage,
});

function ApprovalsPage() {
const { user, isLoading, hasRole, refresh } = useAuth();
  const navigate = useNavigate();
  const [pending, setPending] = useState<PendingUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState<string | null>(null);

  useEffect(() => {
    if (!isLoading && (!user || !hasRole("Admin"))) navigate({ to: "/dashboard" });
  }, [user, isLoading, hasRole, navigate]);

  const load = async () => {
    try {
      const p = await adminApi.pendingUsers();
      setPending(p);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { if (user) load(); }, [user]);

  const act = async (id: string, type: "approve" | "reject") => {
    setBusy(id);
    try {
      if (type === "approve") await adminApi.approve(id);
      else await adminApi.reject(id);
      await load();
      await refresh(); 
    } finally {
      setBusy(null);
    }
  };

  if (isLoading || !user) return null;

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-lg bg-gradient-primary flex items-center justify-center text-primary-foreground">
            <ClipboardCheck className="w-5 h-5" />
          </div>
          <div>
            <h1 className="text-2xl font-bold">Pending Approvals</h1>
            <p className="text-sm text-muted-foreground">Review doctor & specialist registration requests</p>
          </div>
        </div>

        {loading ? (
          <div className="text-center py-16 text-muted-foreground">Loading...</div>
        ) : pending.length === 0 ? (
          <div className="text-center py-16 rounded-xl border border-dashed border-border">
            <ClipboardCheck className="w-12 h-12 mx-auto text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">No pending requests right now.</p>
          </div>
        ) : (
          <div className="space-y-3">
            {pending.map((p) => (
              <div key={p.id} className="rounded-xl border border-border bg-card p-5 flex items-center justify-between flex-wrap gap-3 shadow-soft">
                <div className="flex items-center gap-4">
                  <div className={`w-11 h-11 rounded-lg flex items-center justify-center ${
                    p.requestedRole === "Doctor" ? "bg-info/10 text-info" : "bg-primary/10 text-primary"
                  }`}>
                    {p.requestedRole === "Doctor" ? <Stethoscope className="w-5 h-5" /> : <FlaskConical className="w-5 h-5" />}
                  </div>
                  <div>
                    <p className="font-semibold text-foreground">{p.name}</p>
                    <p className="text-sm text-muted-foreground">{p.email}</p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      Requested role: <span className="font-medium text-foreground">{p.requestedRole}</span> ·
                      Applied {new Date(p.createdAt).toLocaleDateString()}
                    </p>
                  </div>
                </div>
                <div className="flex gap-2">
                  <button
                    onClick={() => act(p.id, "reject")}
                    disabled={busy === p.id}
                    className="inline-flex items-center gap-1 px-3 py-2 rounded-lg border border-destructive/30 text-destructive hover:bg-destructive/10 text-sm font-medium disabled:opacity-50"
                  >
                    <X className="w-4 h-4" /> Reject
                  </button>
                  <button
                    onClick={() => act(p.id, "approve")}
                    disabled={busy === p.id}
                    className="inline-flex items-center gap-1 px-3 py-2 rounded-lg bg-success text-success-foreground hover:opacity-90 text-sm font-medium disabled:opacity-50"
                  >
                    <Check className="w-4 h-4" /> Approve
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}
