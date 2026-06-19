import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { Link, useNavigate } from "@tanstack/react-router";
import { Eye, EyeOff, Fingerprint, Flame, LogIn } from "lucide-react";
import { motion } from "motion/react";
import { useState } from "react";
import { toast } from "sonner";
import { useAuth } from "../hooks/useAuth";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { login, isAuthenticated } = useAuth();
  const navigate = useNavigate();

  if (isAuthenticated) {
    navigate({ to: "/dashboard/user" });
    return null;
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim() || !password.trim()) {
      toast.error("Please enter your email and password");
      return;
    }
    setIsSubmitting(true);
    try {
      // Simulate email/password login (Internet Identity is the real auth)
      await new Promise((res) => setTimeout(res, 800));
      toast.info("Use Internet Identity to log in securely", {
        description: "Click the 'Login with Internet Identity' button below.",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleInternetIdentity = async () => {
    try {
      await login();
      toast.success("Welcome back! 🙏");
      navigate({ to: "/dashboard/user" });
    } catch {
      toast.error("Login failed. Please try again.");
    }
  };

  return (
    <div className="min-h-[calc(100vh-4rem)] flex items-center justify-center bg-background px-4 py-10">
      <motion.div
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="w-full max-w-md"
      >
        {/* Card */}
        <div className="bg-card border border-border rounded-2xl shadow-warm-lg overflow-hidden">
          {/* Top decoration */}
          <div className="h-2 bg-gradient-to-r from-primary via-accent to-primary" />

          <div className="p-8">
            {/* Logo */}
            <div className="flex flex-col items-center gap-3 mb-8">
              <div className="w-14 h-14 rounded-full bg-primary/10 border border-primary/20 flex items-center justify-center">
                <Flame className="w-8 h-8 text-primary" />
              </div>
              <div className="text-center">
                <h1 className="font-display font-bold text-2xl text-foreground">
                  Welcome Back
                </h1>
                <p className="text-sm text-muted-foreground mt-1">
                  Sign in to your account
                </p>
              </div>
            </div>

            {/* Internet Identity Button */}
            <Button
              type="button"
              onClick={handleInternetIdentity}
              className="w-full btn-accessible bg-primary text-primary-foreground hover:bg-primary/90 gap-2 text-base mb-6"
              data-ocid="btn-internet-identity"
            >
              <Fingerprint className="w-5 h-5" />
              Login with Internet Identity
            </Button>

            <div className="flex items-center gap-3 mb-6">
              <Separator className="flex-1" />
              <span className="text-xs text-muted-foreground font-medium">
                or continue with email
              </span>
              <Separator className="flex-1" />
            </div>

            {/* Form */}
            <form
              onSubmit={handleSubmit}
              className="flex flex-col gap-5"
              noValidate
            >
              <div className="flex flex-col gap-2">
                <Label
                  htmlFor="email"
                  className="text-sm font-medium text-foreground"
                >
                  Email Address
                </Label>
                <Input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="you@example.com"
                  autoComplete="email"
                  className="h-12 text-base focus-ring"
                  data-ocid="input-email"
                />
              </div>

              <div className="flex flex-col gap-2">
                <div className="flex items-center justify-between">
                  <Label
                    htmlFor="password"
                    className="text-sm font-medium text-foreground"
                  >
                    Password
                  </Label>
                  <button
                    type="button"
                    className="text-xs text-primary hover:underline focus-ring rounded"
                    data-ocid="btn-forgot-password"
                    onClick={() =>
                      toast.info(
                        "Password recovery is handled by Internet Identity",
                        {
                          description:
                            "Use the 'Login with Internet Identity' button above to access your account securely.",
                        },
                      )
                    }
                  >
                    Forgot password?
                  </button>
                </div>
                <div className="relative">
                  <Input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="Enter your password"
                    autoComplete="current-password"
                    className="h-12 text-base pr-12 focus-ring"
                    data-ocid="input-password"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    aria-label={
                      showPassword ? "Hide password" : "Show password"
                    }
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground focus-ring rounded p-1"
                    data-ocid="toggle-password"
                  >
                    {showPassword ? (
                      <EyeOff className="w-5 h-5" />
                    ) : (
                      <Eye className="w-5 h-5" />
                    )}
                  </button>
                </div>
              </div>

              <Button
                type="submit"
                disabled={isSubmitting}
                className="w-full btn-accessible border border-primary/40 text-primary bg-transparent hover:bg-primary/10 gap-2 text-base mt-1"
                variant="outline"
                data-ocid="btn-submit-login"
              >
                {isSubmitting ? (
                  <span className="flex items-center gap-2">
                    <span className="w-4 h-4 border-2 border-primary/30 border-t-primary rounded-full animate-spin" />
                    Signing in...
                  </span>
                ) : (
                  <>
                    <LogIn className="w-5 h-5" />
                    Sign In
                  </>
                )}
              </Button>
            </form>

            <p className="text-center text-sm text-muted-foreground mt-6">
              Don't have an account?{" "}
              <Link
                to="/register"
                className="text-primary font-medium hover:underline focus-ring rounded"
                data-ocid="link-to-register"
              >
                Register here
              </Link>
            </p>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
