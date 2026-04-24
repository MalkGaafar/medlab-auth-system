import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useAuth } from "../lib/auth-context";
import { Navbar } from "../components/Navbar";
import { reportsApi, labTestsApi, patientsApi, type ClinicalReport, type LabTest } from "../lib/api-client";
import { Plus, FileText, CheckCircle2, Clock, User, Stethoscope, AlertCircle, X } from "lucide-react";

export const Route = createFileRoute("/reports")({
  component: ReportsPage,
});

interface Patient { id: string; name: string; email: string }

function ReportsPage() {
  const { user, isLoading, hasPermission, hasRole } = useAuth();
  const navigate = useNavigate();
  const [reports, setReports] = useState<ClinicalReport[]>([]);
  const [tests, setTests] = useState<LabTest[]>([]);
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCreate, setShowCreate] = useState(false);
  const [working, setWorking] = useState<number | "create" | null>(null);
  const [error, setError] = useState("");
  const [verdictModal, setVerdictModal] = useState<ClinicalReport | null>(null);
  const [verdictText, setVerdictText] = useState("");
  const [verdictNotes, setVerdictNotes] = useState("");

  const [form, setForm] = useState({
    patientId: "",
    labTestId: 0,
    result: "",
    findings: "",
    urgencyLevel: 1,
  });

  useEffect(() => {
    if (!isLoading && !user) navigate({ to: "/" });
  }, [user, isLoading, navigate]);

  const loadData = async () => {
    try {
      setError("");
      const r = await reportsApi.list();
      setReports(r);
      if (hasPermission("reports:create")) {
        const [t, p] = await Promise.all([labTestsApi.list(), patientsApi.list()]);
        setTests(t);
        setPatients(p);
      }
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user) loadData();
  }, [user]); // eslint-disable-line

  if (isLoading || !user) return null;

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    setWorking("create");
    setError("");
    try {
      await reportsApi.create(form);
      setShowCreate(false);
      setForm({ patientId: "", labTestId: 0, result: "", findings: "", urgencyLevel: 1 });
      await loadData();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed");
    } finally {
      setWorking(null);
    }
  };

  const handleClaim = async (id: number) => {
    setWorking(id);
    try {
      await reportsApi.claim(id);
      await loadData();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to claim");
    } finally {
      setWorking(null);
    }
  };

  const handleVerdict = async () => {
    if (!verdictModal) return;
    setWorking(verdictModal.id);
    try {
      await reportsApi.setVerdict(verdictModal.id, verdictText, verdictNotes);
      setVerdictModal(null);
      setVerdictText("");
      setVerdictNotes("");
      await loadData();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed");
    } finally {
      setWorking(null);
    }
  };

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-start justify-between mb-6 flex-wrap gap-4">
          <div>
            <h1 className="text-3xl font-bold text-foreground">Clinical Reports</h1>
            <p className="text-sm text-muted-foreground mt-1">
              {hasRole("Patient") ? "Your laboratory results and physician verdicts." : "All clinical laboratory reports."}
            </p>
          </div>
          {hasPermission("reports:create") && (
            <button
              onClick={() => setShowCreate(!showCreate)}
              className="inline-flex items-center gap-1.5 px-4 py-2 rounded-lg bg-gradient-primary text-primary-foreground font-medium text-sm shadow-soft hover:shadow-glow transition-all"
            >
              {showCreate ? <X className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
              {showCreate ? "Cancel" : "New Report"}
            </button>
          )}
        </div>

        {error && (
          <div className="mb-4 flex items-start gap-2 p-3 rounded-lg bg-destructive/10 text-destructive text-sm">
            <AlertCircle className="w-4 h-4 mt-0.5" />
            <span>{error}</span>
          </div>
        )}

        {showCreate && hasPermission("reports:create") && (
          <div className="mb-6 rounded-xl border border-border bg-card p-6 shadow-soft">
            <h2 className="text-lg font-semibold mb-4">Create new clinical report</h2>
            <form onSubmit={handleCreate} className="grid gap-4 sm:grid-cols-2">
              <Select label="Patient" value={form.patientId} onChange={(v) => setForm({ ...form, patientId: v })}>
                <option value="">Select patient...</option>
                {patients.map((p) => <option key={p.id} value={p.id}>{p.name} ({p.email})</option>)}
              </Select>
              <Select label="Lab Test" value={String(form.labTestId)} onChange={(v) => setForm({ ...form, labTestId: Number(v) })}>
                <option value="0">Select test...</option>
                {tests.map((t) => <option key={t.id} value={t.id}>{t.testName}</option>)}
              </Select>
              <Input label="Result" value={form.result} onChange={(v) => setForm({ ...form, result: v })} placeholder="e.g. 12.5 g/dL" />
              <Select label="Urgency" value={String(form.urgencyLevel)} onChange={(v) => setForm({ ...form, urgencyLevel: Number(v) })}>
                <option value="1">Routine</option>
                <option value="2">Urgent</option>
                <option value="3">Critical</option>
              </Select>
              <div className="sm:col-span-2">
                <label className="block text-sm font-medium mb-1.5">Findings</label>
                <textarea
                  value={form.findings}
                  onChange={(e) => setForm({ ...form, findings: e.target.value })}
                  required
                  rows={3}
                  className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm"
                  placeholder="Specialist findings..."
                />
              </div>
              <div className="sm:col-span-2 flex justify-end">
                <button
                  type="submit"
                  disabled={working === "create"}
                  className="px-5 py-2 rounded-lg bg-gradient-primary text-primary-foreground font-medium text-sm shadow-soft disabled:opacity-50"
                >
                  {working === "create" ? "Creating..." : "Submit Report"}
                </button>
              </div>
            </form>
          </div>
        )}

        {loading ? (
          <div className="text-center py-16 text-muted-foreground">Loading reports...</div>
        ) : reports.length === 0 ? (
          <div className="text-center py-16 rounded-xl border border-dashed border-border">
            <FileText className="w-12 h-12 mx-auto text-muted-foreground/50 mb-3" />
            <p className="text-muted-foreground">No reports available yet.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {reports.map((r) => (
              <ReportCard
                key={r.id}
                report={r}
                canClaim={hasRole("Doctor") && !r.assignedDoctorId}
                canVerdict={hasRole("Doctor") && r.assignedDoctorId === user.id && !r.finalVerdict}
                onClaim={() => handleClaim(r.id)}
                onVerdict={() => { setVerdictModal(r); setVerdictText(r.finalVerdict || ""); setVerdictNotes(r.notes || ""); }}
                working={working === r.id}
              />
            ))}
          </div>
        )}
      </main>

      {/* Verdict Modal */}
      {verdictModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-foreground/40 backdrop-blur-sm p-4">
          <div className="w-full max-w-lg rounded-2xl bg-card shadow-card border border-border p-6">
            <div className="flex items-start justify-between mb-4">
              <div>
                <h3 className="text-lg font-semibold">Final Verdict</h3>
                <p className="text-sm text-muted-foreground">{verdictModal.labTestName} — {verdictModal.patientName}</p>
              </div>
              <button onClick={() => setVerdictModal(null)} className="p-1 rounded hover:bg-accent">
                <X className="w-5 h-5" />
              </button>
            </div>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1.5">Final Verdict</label>
                <textarea
                  value={verdictText}
                  onChange={(e) => setVerdictText(e.target.value)}
                  rows={3}
                  className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm"
                  placeholder="Your clinical verdict..."
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1.5">Additional Notes</label>
                <textarea
                  value={verdictNotes}
                  onChange={(e) => setVerdictNotes(e.target.value)}
                  rows={2}
                  className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm"
                  placeholder="Optional notes..."
                />
              </div>
              <div className="flex justify-end gap-2">
                <button
                  onClick={() => setVerdictModal(null)}
                  className="px-4 py-2 rounded-lg border border-input text-sm"
                >
                  Cancel
                </button>
                <button
                  onClick={handleVerdict}
                  disabled={!verdictText.trim() || working === verdictModal.id}
                  className="px-4 py-2 rounded-lg bg-gradient-primary text-primary-foreground text-sm font-medium disabled:opacity-50"
                >
                  {working === verdictModal.id ? "Saving..." : "Submit Verdict"}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function ReportCard({
  report, canClaim, canVerdict, onClaim, onVerdict, working,
}: {
  report: ClinicalReport;
  canClaim: boolean;
  canVerdict: boolean;
  onClaim: () => void;
  onVerdict: () => void;
  working: boolean;
}) {
  const urgencyTone = report.urgencyLevel >= 3 ? "destructive" : report.urgencyLevel === 2 ? "warning" : "muted";
  const urgencyLabel = report.urgencyLevel >= 3 ? "Critical" : report.urgencyLevel === 2 ? "Urgent" : "Routine";
  const verdictGiven = !!report.finalVerdict;
  const assigned = !!report.assignedDoctorId;

  return (
    <div className="rounded-xl border border-border bg-card p-6 shadow-soft hover:shadow-card transition-shadow">
      <div className="flex items-start justify-between flex-wrap gap-3 mb-4">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            <h3 className="text-lg font-semibold text-foreground">{report.labTestName}</h3>
            <span className={`px-2 py-0.5 rounded-md text-xs font-semibold ${
              urgencyTone === "destructive" ? "bg-destructive/10 text-destructive" :
              urgencyTone === "warning" ? "bg-warning/10 text-warning-foreground" :
              "bg-muted text-muted-foreground"
            }`}>{urgencyLabel}</span>
            {verdictGiven ? (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-xs font-semibold bg-success/10 text-success">
                <CheckCircle2 className="w-3 h-3" /> Verdict Given
              </span>
            ) : assigned ? (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-xs font-semibold bg-info/10 text-info">
                <Clock className="w-3 h-3" /> In Review
              </span>
            ) : (
              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-xs font-semibold bg-warning/10 text-warning-foreground">
                <Clock className="w-3 h-3" /> Awaiting Doctor
              </span>
            )}
          </div>
          <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-sm text-muted-foreground">
            <span className="inline-flex items-center gap-1"><User className="w-3.5 h-3.5" />{report.patientName}</span>
            <span className="inline-flex items-center gap-1"><Stethoscope className="w-3.5 h-3.5" />Specialist: {report.createdByName}</span>
            {report.assignedDoctorName && (
              <span className="inline-flex items-center gap-1 text-info">Dr. {report.assignedDoctorName}</span>
            )}
          </div>
        </div>
        <div className="flex gap-2">
          {canClaim && (
            <button
              onClick={onClaim}
              disabled={working}
              className="px-3 py-1.5 rounded-lg bg-info/10 text-info hover:bg-info/20 text-sm font-medium disabled:opacity-50"
            >
              {working ? "Claiming..." : "Claim Report"}
            </button>
          )}
          {canVerdict && (
            <button
              onClick={onVerdict}
              className="px-3 py-1.5 rounded-lg bg-gradient-primary text-primary-foreground text-sm font-medium shadow-soft"
            >
              Add Verdict
            </button>
          )}
        </div>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 text-sm bg-muted/40 rounded-lg p-4">
        <div>
          <p className="text-xs uppercase tracking-wide text-muted-foreground mb-0.5">Result</p>
          <p className="font-medium text-foreground">{report.result}</p>
        </div>
        <div>
          <p className="text-xs uppercase tracking-wide text-muted-foreground mb-0.5">Normal Range</p>
          <p className="font-medium text-foreground">{report.normalRange || "—"}</p>
        </div>
        {report.findings && (
          <div className="sm:col-span-2">
            <p className="text-xs uppercase tracking-wide text-muted-foreground mb-0.5">Specialist Findings</p>
            <p className="text-foreground">{report.findings}</p>
          </div>
        )}
      </div>

      {verdictGiven && (
        <div className="mt-4 p-4 rounded-lg border-l-4 border-success bg-success/5">
          <p className="text-xs uppercase tracking-wide text-success font-semibold mb-1">Doctor's Final Verdict</p>
          <p className="text-foreground font-medium">{report.finalVerdict}</p>
          {report.notes && <p className="mt-2 text-sm text-muted-foreground italic">"{report.notes}"</p>}
          {report.verdictGivenAt && (
            <p className="mt-2 text-xs text-muted-foreground">
              Issued {new Date(report.verdictGivenAt).toLocaleString()} by Dr. {report.assignedDoctorName}
            </p>
          )}
        </div>
      )}

      <p className="mt-3 text-xs text-muted-foreground">
        Reported {new Date(report.reportDate).toLocaleString()}
      </p>
    </div>
  );
}

function Input({ label, value, onChange, placeholder }: { label: string; value: string; onChange: (v: string) => void; placeholder?: string }) {
  return (
    <div>
      <label className="block text-sm font-medium mb-1.5">{label}</label>
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        required
        placeholder={placeholder}
        className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm focus:outline-none focus:ring-2 focus:ring-ring"
      />
    </div>
  );
}

function Select({ label, value, onChange, children }: { label: string; value: string; onChange: (v: string) => void; children: React.ReactNode }) {
  return (
    <div>
      <label className="block text-sm font-medium mb-1.5">{label}</label>
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        required
        className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-sm focus:outline-none focus:ring-2 focus:ring-ring"
      >
        {children}
      </select>
    </div>
  );
}
