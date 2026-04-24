import { createFileRoute, useNavigate, Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useAuth } from "../lib/auth-context";
import { Navbar } from "../components/Navbar";
import { reportsApi, adminApi, type ClinicalReport } from "../lib/api-client";
import { FileText, FlaskConical, ClipboardCheck, Users, Activity, Clock, CheckCircle2, AlertTriangle } from "lucide-react";

export const Route = createFileRoute("/dashboard")({
  component: DashboardPage,
});

function DashboardPage() {
  const { user, isLoading, hasRole } = useAuth();
  const navigate = useNavigate();
  const [reports, setReports] = useState<ClinicalReport[]>([]);
  const [pendingCount, setPendingCount] = useState(0);
  const [loadingStats, setLoadingStats] = useState(true);

  useEffect(() => {
    if (!isLoading && !user) navigate({ to: "/" });
  }, [user, isLoading, navigate]);

  useEffect(() => {
    if (!user) return;
    (async () => {
      setLoadingStats(true);
      try {
        // Use Promise.allSettled to allow the dashboard to load even if one API fails
        const [reportsRes, pendingRes] = await Promise.allSettled([
          reportsApi.list(),
          hasRole("Admin") ? adminApi.pendingUsers() : Promise.resolve([])
        ]);

        if (reportsRes.status === 'fulfilled') setReports(reportsRes.value);
        if (pendingRes.status === 'fulfilled') setPendingCount(pendingRes.value.length);
      } catch (e) {
        console.error(e);
      } finally {
        setLoadingStats(false);
      }
    })();
  }, [user, hasRole]);

  if (isLoading || !user) return null;

  const totalReports = reports.length;
  const verdictGiven = reports.filter((r) => r.finalVerdict).length;
  const awaitingVerdict = reports.filter((r) => !r.finalVerdict).length;
  const unassigned = reports.filter((r) => !r.assignedDoctorId).length;

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Hero */}
        <div className="mb-8 rounded-2xl bg-gradient-hero p-8 text-primary-foreground relative overflow-hidden shadow-card">
          <div className="absolute inset-0 bg-grid opacity-20" />
          <div className="relative">
            <p className="text-sm opacity-80 mb-1">Welcome back,</p>
            <h1 className="text-3xl font-bold">{user.name}</h1>
            <p className="mt-2 opacity-90">
              {hasRole("Patient") && "Track your laboratory results and physician verdicts."}
              {hasRole("Doctor") && "Review pending reports and provide your final clinical verdict."}
              {hasRole("Specialist") && "Manage lab tests and create new clinical reports."}
              {hasRole("Admin") && "Manage user approvals, roles and platform users."}
            </p>
          </div>
        </div>

        {/* Stats */}
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4 mb-8">
          <StatCard icon={<FileText className="w-5 h-5" />} label="Total Reports" value={loadingStats ? "—" : totalReports} tone="primary" />
          <StatCard icon={<CheckCircle2 className="w-5 h-5" />} label="With Verdict" value={loadingStats ? "—" : verdictGiven} tone="success" />
          <StatCard icon={<Clock className="w-5 h-5" />} label="Awaiting Verdict" value={loadingStats ? "—" : awaitingVerdict} tone="warning" />
          {hasRole("Admin") ? (
            <StatCard icon={<AlertTriangle className="w-5 h-5" />} label="Pending Approvals" value={loadingStats ? "—" : pendingCount} tone="info" />
          ) : (
            <StatCard icon={<Activity className="w-5 h-5" />} label="Unassigned" value={loadingStats ? "—" : unassigned} tone="info" />
          )}
        </div>

        {/* Quick actions */}
        <h2 className="text-lg font-semibold mb-4">Quick actions</h2>
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          <ActionCard
            to="/reports"
            icon={<FileText />}
            title={hasRole("Patient") ? "My Lab Reports" : "All Reports"}
            desc={hasRole("Patient") ? "View your test results and physician verdicts." : "Browse, claim, and review patient reports."}
          />

          {hasRole("Specialist") && (
            <ActionCard
              to="/labtests"
              icon={<FlaskConical />}
              title="Lab Tests Catalog"
              desc="Define new tests and normal reference ranges."
            />
          )}

          {hasRole("Admin") && (
            <>
              <ActionCard
                to="/approvals"
                icon={<ClipboardCheck />}
                title="Pending Approvals"
                desc="Review doctor & specialist registration requests."
                badge={pendingCount > 0 ? pendingCount : undefined}
              />
              <ActionCard
                to="/admin"
                icon={<Users />}
                title="User Management"
                desc="Manage platform users and assigned roles."
              />
            </>
          )}
        </div>
      </main>
    </div>
  );
}

function StatCard({ icon, label, value, tone }: { icon: React.ReactNode; label: string; value: number | string; tone: "primary" | "success" | "warning" | "info" }) {
  const tones = {
    primary: "bg-primary/10 text-primary",
    success: "bg-success/10 text-success",
    warning: "bg-warning/10 text-warning-foreground",
    info: "bg-info/10 text-info",
  };
  return (
    <div className="rounded-xl border border-border bg-card p-5 shadow-soft">
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm text-muted-foreground">{label}</p>
        <div className={`w-9 h-9 rounded-lg flex items-center justify-center ${tones[tone]}`}>{icon}</div>
      </div>
      <p className="text-3xl font-bold text-foreground">{value}</p>
    </div>
  );
}

function ActionCard({ to, icon, title, desc, badge }: { to: string; icon: React.ReactNode; title: string; desc: string; badge?: number }) {
  return (
    <Link
      to={to}
      className="group rounded-xl border border-border bg-card p-6 hover:border-primary/40 hover:shadow-card transition-all"
    >
      <div className="flex items-start justify-between mb-3">
        <div className="w-11 h-11 rounded-lg bg-gradient-primary text-primary-foreground flex items-center justify-center shadow-soft group-hover:shadow-glow transition-all">
          {icon}
        </div>
        {badge !== undefined && (
          <span className="px-2 py-0.5 rounded-full bg-destructive text-destructive-foreground text-xs font-bold">
            {badge}
          </span>
        )}
      </div>
      <h3 className="font-semibold text-foreground mb-1">{title}</h3>
      <p className="text-sm text-muted-foreground">{desc}</p>
    </Link>
  );
}
