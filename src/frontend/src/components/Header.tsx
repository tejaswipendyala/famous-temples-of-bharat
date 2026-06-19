import { Button } from "@/components/ui/button";
import { Link, useNavigate } from "@tanstack/react-router";
import {
  Flame,
  LayoutDashboard,
  LogOut,
  Menu,
  Moon,
  Sun,
  User,
  X,
} from "lucide-react";
import { useState } from "react";
import { useAuth } from "../hooks/useAuth";
import { useUserProfile } from "../hooks/useUserProfile";

interface HeaderProps {
  isDark: boolean;
  onToggleTheme: () => void;
}

const NAV_LINKS = [
  { label: "Home", to: "/" },
  { label: "Explore Temples", to: "/temples" },
];

export default function Header({ isDark, onToggleTheme }: HeaderProps) {
  const [menuOpen, setMenuOpen] = useState(false);
  const { isAuthenticated, logout } = useAuth();
  const { profile, isAdmin } = useUserProfile();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await logout();
    setMenuOpen(false);
    navigate({ to: "/" });
  };

  return (
    <header className="sticky top-0 z-50 bg-card border-b border-border shadow-warm-sm">
      <div className="container mx-auto px-4 h-16 flex items-center justify-between gap-4">
        {/* Logo */}
        <Link
          to="/"
          className="flex items-center gap-2 group shrink-0"
          data-ocid="header-logo"
        >
          <div className="w-9 h-9 rounded-full bg-primary flex items-center justify-center shadow-warm-sm">
            <Flame className="w-5 h-5 text-primary-foreground" />
          </div>
          <div className="hidden sm:block">
            <div className="font-display font-bold text-sm leading-tight text-foreground">
              Famous Temples
            </div>
            <div className="text-xs text-muted-foreground leading-tight">
              of Bharat
            </div>
          </div>
        </Link>

        {/* Desktop Nav */}
        <nav
          className="hidden md:flex items-center gap-1"
          aria-label="Main navigation"
        >
          {NAV_LINKS.map((link) => (
            <Link
              key={link.to}
              to={link.to}
              className="px-4 py-2 rounded-md text-sm font-medium text-foreground hover:bg-secondary hover:text-secondary-foreground transition-colors duration-200 focus-ring"
              activeProps={{
                className: "bg-secondary text-secondary-foreground",
              }}
              data-ocid={`nav-${link.label.toLowerCase().replace(/\s+/g, "-")}`}
            >
              {link.label}
            </Link>
          ))}
          {isAuthenticated && (
            <Link
              to={isAdmin ? "/dashboard/admin" : "/dashboard/user"}
              className="px-4 py-2 rounded-md text-sm font-medium text-foreground hover:bg-secondary transition-colors duration-200 focus-ring"
              data-ocid="nav-dashboard"
            >
              Dashboard
            </Link>
          )}
        </nav>

        {/* Right Controls */}
        <div className="flex items-center gap-2">
          {/* Theme Toggle */}
          <Button
            variant="ghost"
            size="icon"
            onClick={onToggleTheme}
            aria-label={isDark ? "Switch to light mode" : "Switch to dark mode"}
            className="btn-accessible focus-ring"
            data-ocid="toggle-theme"
          >
            {isDark ? (
              <Sun className="w-5 h-5" />
            ) : (
              <Moon className="w-5 h-5" />
            )}
          </Button>

          {/* Auth Actions */}
          {isAuthenticated ? (
            <div className="hidden md:flex items-center gap-2">
              <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-secondary text-secondary-foreground text-sm font-medium">
                <User className="w-4 h-4" />
                <span className="max-w-[120px] truncate">
                  {profile?.name ?? "User"}
                </span>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={handleLogout}
                aria-label="Logout"
                className="focus-ring"
                data-ocid="btn-logout"
              >
                <LogOut className="w-5 h-5" />
              </Button>
            </div>
          ) : (
            <div className="hidden md:flex items-center gap-2">
              <Button
                variant="ghost"
                asChild
                className="btn-accessible focus-ring text-sm"
                data-ocid="btn-login"
              >
                <Link to="/login">Login</Link>
              </Button>
              <Button
                asChild
                className="btn-accessible focus-ring text-sm bg-primary text-primary-foreground hover:bg-primary/90"
                data-ocid="btn-register"
              >
                <Link to="/register">Register</Link>
              </Button>
            </div>
          )}

          {/* Mobile Hamburger */}
          <Button
            variant="ghost"
            size="icon"
            className="md:hidden btn-accessible focus-ring"
            onClick={() => setMenuOpen(!menuOpen)}
            aria-label={menuOpen ? "Close menu" : "Open menu"}
            aria-expanded={menuOpen}
            type="button"
            data-ocid="btn-hamburger"
          >
            {menuOpen ? (
              <X className="w-5 h-5" />
            ) : (
              <Menu className="w-5 h-5" />
            )}
          </Button>
        </div>
      </div>

      {/* Mobile Menu */}
      {menuOpen && (
        <div
          className="md:hidden border-t border-border bg-card px-4 py-4 flex flex-col gap-2"
          data-ocid="mobile-menu"
        >
          {NAV_LINKS.map((link) => (
            <Link
              key={link.to}
              to={link.to}
              onClick={() => setMenuOpen(false)}
              className="flex items-center gap-3 px-4 py-3 rounded-lg text-base font-medium text-foreground hover:bg-secondary transition-colors"
              data-ocid={`mobile-nav-${link.label.toLowerCase().replace(/\s+/g, "-")}`}
            >
              {link.label}
            </Link>
          ))}
          {isAuthenticated && (
            <Link
              to={isAdmin ? "/dashboard/admin" : "/dashboard/user"}
              onClick={() => setMenuOpen(false)}
              className="flex items-center gap-3 px-4 py-3 rounded-lg text-base font-medium text-foreground hover:bg-secondary transition-colors"
              data-ocid="mobile-nav-dashboard"
            >
              <LayoutDashboard className="w-5 h-5" />
              Dashboard
            </Link>
          )}
          <div className="h-px bg-border my-1" />
          {isAuthenticated ? (
            <button
              type="button"
              onClick={handleLogout}
              className="flex items-center gap-3 px-4 py-3 rounded-lg text-base font-medium text-destructive hover:bg-destructive/10 transition-colors w-full text-left"
              data-ocid="mobile-btn-logout"
            >
              <LogOut className="w-5 h-5" />
              Logout
            </button>
          ) : (
            <div className="flex flex-col gap-2">
              <Link
                to="/login"
                onClick={() => setMenuOpen(false)}
                className="flex items-center justify-center px-4 py-3 rounded-lg text-base font-medium border border-border hover:bg-secondary transition-colors"
                data-ocid="mobile-btn-login"
              >
                Login
              </Link>
              <Link
                to="/register"
                onClick={() => setMenuOpen(false)}
                className="flex items-center justify-center px-4 py-3 rounded-lg text-base font-medium bg-primary text-primary-foreground hover:bg-primary/90 transition-colors"
                data-ocid="mobile-btn-register"
              >
                Register
              </Link>
            </div>
          )}
        </div>
      )}
    </header>
  );
}
