import { Link, useNavigate } from "@tanstack/react-router";
import { useAuth } from "../lib/auth-context";
import { Activity, LogOut, LayoutDashboard, FileText, Users, FlaskConical, ClipboardCheck } from "lucide-react";

export function Navbar() {
  const { user, logout, hasRole } = useAuth();
  const navigate = useNavigate();

  if (!user) return null;

  const handleLogout = async () => {
    await logout();
    navigate({ to: "/" });
  };

  const roleColor: Record<string, string> = {
    Admin: "bg-destructive/10 text-destructive",
    Doctor: "bg-info/10 text-info",
    Specialist: "bg-primary/10 text-primary",
    Patient: "bg-success/10 text-success",
  };

  return (
    <nav className="sticky top-0 z-40 border-b border-border bg-card/80 backdrop-blur-md">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 items-center justify-between">
          <div className="flex items-center gap-8">
            <Link to="/dashboard" className="flex items-center gap-2 font-bold text-lg">
              <div className="w-9 h-9 rounded-lg bg-gradient-primary flex items-center justify-center shadow-soft">
                <Activity className="w-5 h-5 text-primary-foreground" />
              </div>
              <span className="bg-gradient-primary bg-clip-text text-transparent">MedLab</span>
            </Link>
            <div className="hidden md:flex items-center gap-1">
              <NavLink to="/dashboard" icon={<LayoutDashboard className="w-4 h-4" />}>Dashboard</NavLink>
              <NavLink to="/reports" icon={<FileText className="w-4 h-4" />}>Reports</NavLink>
              {hasRole("Specialist") && (
                <NavLink to="/labtests" icon={<FlaskConical className="w-4 h-4" />}>Lab Tests</NavLink>
              )}
              {hasRole("Admin") && (
                <>
                  <NavLink to="/approvals" icon={<ClipboardCheck className="w-4 h-4" />}>Approvals</NavLink>
                  <NavLink to="/admin" icon={<Users className="w-4 h-4" />}>Users</NavLink>
                </>
              )}
            </div>
          </div>

          <div className="flex items-center gap-3">
            <div className="hidden sm:flex items-center gap-3">
              <div className="text-right">
                <p className="text-sm font-medium text-foreground leading-tight">{user.name}</p>
                <p className="text-xs text-muted-foreground">{user.email}</p>
              </div>
              <span className={`px-2.5 py-1 rounded-md text-xs font-semibold ${roleColor[user.roles[0]] || "bg-muted"}`}>
                {user.roles[0]}
              </span>
            </div>
            <button
              onClick={handleLogout}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm rounded-md border border-input text-foreground hover:bg-accent transition-colors"
            >
              <LogOut className="w-4 h-4" />
              <span className="hidden sm:inline">Logout</span>
            </button>
          </div>
        </div>
      </div>
    </nav>
  );
}

function NavLink({ to, icon, children }: { to: string; icon: React.ReactNode; children: React.ReactNode }) {
  return (
    <Link
      to={to}
      className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-md text-sm text-muted-foreground hover:text-foreground hover:bg-accent transition-colors"
      activeProps={{ className: "inline-flex items-center gap-1.5 px-3 py-1.5 rounded-md text-sm font-medium text-primary bg-primary/10" }}
    >
      {icon}
      {children}
    </Link>
  );
}
