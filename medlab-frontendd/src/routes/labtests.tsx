import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useAuth } from "../lib/auth-context";
import { Navbar } from "../components/Navbar";
import { labTestsApi, type LabTest } from "../lib/api-client";
import { FlaskConical, Plus, X, AlertCircle } from "lucide-react";

export const Route = createFileRoute("/labtests")({
  component: LabTestsPage,
});

function LabTestsPage() {
  const { user, isLoading, hasRole } = useAuth();
  const navigate = useNavigate();
  const [tests, setTests] = useState<LabTest[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCreate, setShowCreate] = useState(false);
  const [creating, setCreating] = useState(false);
  const [error, setError] = useState("");
  const [form, setForm] = useState({ testName: "", description: "", normalRange: "" });

  useEffect(() => {
    if (!isLoading && (!user || !hasRole("Specialist"))) navigate({ to: "/dashboard" });
  }, [user, isLoading, hasRole, navigate]);

  const load = async () => {
    try {
      const t = await labTestsApi.list();
      setTests(t);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { if (user) load(); }, [user]);

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    setCreating(true);
    setError("");
    try {
      await labTestsApi.create(form);
      setForm({ testName: "", description: "", normalRange: "" });
      setShowCreate(false);
      await load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed");
    } finally {
      setCreating(false);
    }
  };

  if (isLoading || !user) return null;

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-start justify-between flex-wrap gap-4 mb-6">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-gradient-primary flex items-center justify-center text-primary-foreground">
              <FlaskConical className="w-5 h-5" />
            </div>
            <div>
              <h1 className="text-2xl font-bold">Lab Tests Catalog</h1>
              <p className="text-sm text-muted-foreground">Define tests and normal reference ranges</p>
            </div>
          </div>
          <button
            onClick={() => setShowCreate(!showCreate)}
            className="inline-flex items-center gap-1.5 px-4 py-2 rounded-lg bg-gradient-primary text-primary-foreground font-medium text-sm shadow-soft"
          >
            {showCreate ? <X className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
            {showCreate ? "Cancel" : "New Test"}
          </button>
        </div>

        {error && (
          <div className="mb-4 flex items-start gap-2 p-3 rounded-lg bg-destructive/10 text-destructive text-sm">
            <AlertCircle className="w-4 h-4 mt-0.5" /> <span>{error}</span>
          </div>
        )}

        {showCreate && (
          <div className="mb-6 rounded-xl border border-border bg-card p-6 shadow-soft">
            <form onSubmit={handleCreate} className="grid gap-4 sm:grid-cols-2">
              <div>
                <label className="block text-sm font-medium mb-1.5">Test Name</label>
                <input
                  required
                  value={form.testName}
                  onChange={(e) => setForm({ ...form, testName: e.target.value })}
                  placeholder="e.g. Complete Blood Count"
                  className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1.5">Normal Range</label>
                <input
                  required
                  value={form.normalRange}
                  onChange={(e) => setForm({ ...form, normalRange: e.target.value })}
                  placeholder="e.g. 4.5-11.0 x10^9/L"
                  className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm"
                />
              </div>
              <div className="sm:col-span-2">
                <label className="block text-sm font-medium mb-1.5">Description</label>
                <textarea
                  value={form.description}
                  onChange={(e) => setForm({ ...form, description: e.target.value })}
                  rows={3}
                  placeholder="What this test measures..."
                  className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm"
                />
              </div>
              <div className="sm:col-span-2 flex justify-end">
                <button
                  type="submit"
                  disabled={creating}
                  className="px-5 py-2 rounded-lg bg-gradient-primary text-primary-foreground font-medium text-sm shadow-soft disabled:opacity-50"
                >
                  {creating ? "Saving..." : "Save Test"}
                </button>
              </div>
            </form>
          </div>
        )}

        {loading ? (
          <div className="text-center py-16 text-muted-foreground">Loading...</div>
        ) : tests.length === 0 ? (
          <div className="text-center py-16 rounded-xl border border-dashed border-border">
            <FlaskConical className="w-12 h-12 mx-auto text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">No lab tests defined yet.</p>
          </div>
        ) : (
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {tests.map((t) => (
              <div key={t.id} className="rounded-xl border border-border bg-card p-5 shadow-soft hover:shadow-card transition-shadow">
                <div className="flex items-start gap-3 mb-3">
                  <div className="w-10 h-10 rounded-lg bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
                    <FlaskConical className="w-5 h-5" />
                  </div>
                  <div className="min-w-0">
                    <h3 className="font-semibold text-foreground">{t.testName}</h3>
                    <p className="text-xs text-muted-foreground">
                      Added {new Date(t.createdAt).toLocaleDateString()}
                    </p>
                  </div>
                </div>
                {t.description && <p className="text-sm text-muted-foreground mb-3">{t.description}</p>}
                <div className="rounded-lg bg-muted/40 p-3">
                  <p className="text-xs uppercase tracking-wide text-muted-foreground mb-0.5">Normal Range</p>
                  <p className="text-sm font-medium text-foreground">{t.normalRange}</p>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}
