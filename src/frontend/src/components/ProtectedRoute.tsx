import { Skeleton } from "@/components/ui/skeleton";
import { Navigate } from "@tanstack/react-router";
import { Flame } from "lucide-react";
import { useAuth } from "../hooks/useAuth";
import { useUserProfile } from "../hooks/useUserProfile";

interface ProtectedRouteProps {
  children: React.ReactNode;
  requireAdmin?: boolean;
  redirectTo?: string;
}

export default function ProtectedRoute({
  children,
  requireAdmin = false,
  redirectTo = "/login",
}: ProtectedRouteProps) {
  const { isAuthenticated, isLoading } = useAuth();
  const { isAdmin, isLoading: profileLoading } = useUserProfile();

  if (isLoading || profileLoading) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center bg-background gap-6">
        <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center animate-pulse">
          <Flame className="w-7 h-7 text-primary" />
        </div>
        <div className="flex flex-col items-center gap-3 w-64">
          <Skeleton className="h-4 w-48 rounded-full" />
          <Skeleton className="h-3 w-36 rounded-full" />
        </div>
        <p className="text-sm text-muted-foreground">Loading your journey...</p>
      </div>
    );
  }

  if (!isAuthenticated) {
    return <Navigate to={redirectTo} />;
  }

  if (requireAdmin && !isAdmin) {
    return <Navigate to="/dashboard/user" />;
  }

  return <>{children}</>;
}
