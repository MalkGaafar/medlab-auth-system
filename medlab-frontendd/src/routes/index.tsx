import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { useAuth } from "../lib/auth-context";
import type { Role } from "../lib/api-client";
import { Activity, Stethoscope, FlaskConical, UserRound, Shield, CheckCircle2, AlertCircle } from "lucide-react";

export const Route = createFileRoute("/")({
  component: LoginPage,
});

function LoginPage() {
  const { user, isLoading, login, register } = useAuth();
  const navigate = useNavigate();
  const [mode, setMode] = useState<"login" | "register">("login");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [role, setRole] = useState<Role>("Patient");
  const [error, setError] = useState("");
  const [info, setInfo] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!isLoading && user) navigate({ to: "/dashboard" });
  }, [user, isLoading, navigate]);

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="animate-pulse text-muted-foreground">Loading...</div>
      </div>
    );
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setInfo("");
    setLoading(true);
    try {
      if (mode === "login") {
        const res = await login(email, password);
        if (res.success) navigate({ to: "/dashboard" });
        else setError(res.error || "Login failed");
      } else {
        const res = await register(email, password, name, role);
        if (res.success) {
          if (res.requiresApproval) {
            setInfo("Registration submitted. Your account is awaiting administrator approval.");
            setMode("login");
            setName("");
            setPassword("");
          } else {
            // Patient auto-approved -> auto-login
            const lr = await login(email, password);
            if (lr.success) navigate({ to: "/dashboard" });
          }
        } else {
          setError(res.error || "Registration failed");
        }
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen">
      {/* Left Hero */}
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-hero relative overflow-hidden">
        <div className="absolute inset-0 bg-grid opacity-30" />
        <div className="relative flex flex-col justify-between p-12 text-primary-foreground w-full">
          <div className="flex items-center gap-3">
            <div className="w-11 h-11 rounded-xl bg-white/15 backdrop-blur flex items-center justify-center">
              <Activity className="w-6 h-6" />
            </div>
            <span className="text-2xl font-bold">MedLab</span>
          </div>

          <div className="max-w-lg">
            <h1 className="text-5xl font-bold leading-tight mb-6">
              Modern Laboratory<br />Management Platform
            </h1>
            <p className="text-lg opacity-90 mb-10 leading-relaxed">
              Connecting patients, specialists, and physicians through a unified clinical workflow.
            </p>

            <div className="grid grid-cols-2 gap-4">
              <FeatureCard icon={<UserRound className="w-5 h-5" />} title="Patients" desc="Track lab results & verdicts" />
              <FeatureCard icon={<FlaskConical className="w-5 h-5" />} title="Specialists" desc="Run tests & log findings" />
              <FeatureCard icon={<Stethoscope className="w-5 h-5" />} title="Doctors" desc="Review & sign final verdicts" />
              <FeatureCard icon={<Shield className="w-5 h-5" />} title="Admins" desc="Manage approvals & roles" />
            </div>
          </div>

          <p className="text-sm opacity-70">© {new Date().getFullYear()} MedLab Clinical Systems</p>
        </div>
      </div>

      {/* Right Form */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-6 sm:p-12 bg-background">
        <div className="w-full max-w-md">
          <div className="lg:hidden flex items-center gap-2 mb-8">
            <div className="w-9 h-9 rounded-lg bg-gradient-primary flex items-center justify-center">
              <Activity className="w-5 h-5 text-primary-foreground" />
            </div>
            <span className="text-xl font-bold bg-gradient-primary bg-clip-text text-transparent">MedLab</span>
          </div>

          <h2 className="text-3xl font-bold text-foreground">
            {mode === "login" ? "Welcome back" : "Create your account"}
          </h2>
          <p className="mt-2 text-sm text-muted-foreground">
            {mode === "login"
              ? "Sign in to access your laboratory portal."
              : "Join MedLab and access clinical reporting tools."}
          </p>

          {error && (
            <div className="mt-5 flex items-start gap-2 p-3 rounded-lg bg-destructive/10 text-destructive text-sm">
              <AlertCircle className="w-4 h-4 mt-0.5 flex-shrink-0" />
              <span>{error}</span>
            </div>
          )}
          {info && (
            <div className="mt-5 flex items-start gap-2 p-3 rounded-lg bg-success/10 text-success text-sm">
              <CheckCircle2 className="w-4 h-4 mt-0.5 flex-shrink-0" />
              <span>{info}</span>
            </div>
          )}

          <form onSubmit={handleSubmit} className="mt-6 space-y-4">
            {mode === "register" && (
              <Field label="Full Name" id="name" value={name} onChange={setName} placeholder="Dr. Jane Doe" />
            )}
            <Field label="Email" id="email" type="email" value={email} onChange={setEmail} placeholder="you@hospital.com" />
            <Field
              label="Password"
              id="password"
              type="password"
              value={password}
              onChange={setPassword}
              placeholder="••••••••"
              hint={mode === "register" ? "Min 8 chars, uppercase, lowercase, number & special" : undefined}
            />

            {mode === "register" && (
              <div>
                <label className="block text-sm font-medium text-foreground mb-1.5">Register as</label>
                <div className="grid grid-cols-3 gap-2">
                  {(["Patient", "Doctor", "Specialist"] as Role[]).map((r) => (
                    <button
                      type="button"
                      key={r}
                      onClick={() => setRole(r)}
                      className={`px-3 py-2.5 rounded-lg border text-sm font-medium transition-all ${
                        role === r
                          ? "border-primary bg-primary/5 text-primary shadow-soft"
                          : "border-input text-muted-foreground hover:border-border hover:text-foreground"
                      }`}
                    >
                      {r}
                    </button>
                  ))}
                </div>
                {role !== "Patient" && (
                  <p className="mt-2 text-xs text-muted-foreground">
                    {role} accounts require administrator approval before login.
                  </p>
                )}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full py-2.5 rounded-lg bg-gradient-primary text-primary-foreground font-medium text-sm shadow-soft hover:shadow-glow transition-all disabled:opacity-50"
            >
              {loading ? "Please wait..." : mode === "login" ? "Sign In" : "Create Account"}
            </button>
          </form>

          <p className="mt-6 text-center text-sm text-muted-foreground">
            {mode === "login" ? (
              <>
                New to MedLab?{" "}
                <button onClick={() => { setMode("register"); setError(""); setInfo(""); }} className="text-primary font-medium hover:underline">
                  Create an account
                </button>
              </>
            ) : (
              <>
                Already have an account?{" "}
                <button onClick={() => { setMode("login"); setError(""); setInfo(""); }} className="text-primary font-medium hover:underline">
                  Sign in
                </button>
              </>
            )}
          </p>
        </div>
      </div>
    </div>
  );
}

function FeatureCard({ icon, title, desc }: { icon: React.ReactNode; title: string; desc: string }) {
  return (
    <div className="p-4 rounded-xl bg-white/10 backdrop-blur border border-white/15">
      <div className="w-9 h-9 rounded-lg bg-white/15 flex items-center justify-center mb-2">{icon}</div>
      <p className="font-semibold text-sm">{title}</p>
      <p className="text-xs opacity-80 mt-0.5">{desc}</p>
    </div>
  );
}

function Field({
  label, id, value, onChange, type = "text", placeholder, hint,
}: { label: string; id: string; value: string; onChange: (v: string) => void; type?: string; placeholder?: string; hint?: string }) {
  return (
    <div>
      <label htmlFor={id} className="block text-sm font-medium text-foreground mb-1.5">{label}</label>
      <input
        id={id}
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        required
        placeholder={placeholder}
        className="w-full px-3.5 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent transition-all"
      />
      {hint && <p className="mt-1 text-xs text-muted-foreground">{hint}</p>}
    </div>
  );
}
