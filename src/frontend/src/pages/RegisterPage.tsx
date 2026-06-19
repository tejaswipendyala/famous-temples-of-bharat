import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { Link, useNavigate } from "@tanstack/react-router";
import {
  CheckCircle2,
  Eye,
  EyeOff,
  Fingerprint,
  Flame,
  UserPlus,
} from "lucide-react";
import { motion } from "motion/react";
import { useState } from "react";
import { toast } from "sonner";
import { useAuth } from "../hooks/useAuth";
import { useUserProfile } from "../hooks/useUserProfile";

interface FormErrors {
  name?: string;
  email?: string;
  password?: string;
  confirmPassword?: string;
}

export default function RegisterPage() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [errors, setErrors] = useState<FormErrors>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { login, isAuthenticated } = useAuth();
  const { saveProfile } = useUserProfile();
  const navigate = useNavigate();

  if (isAuthenticated) {
    navigate({ to: "/dashboard/user" });
    return null;
  }

  const validate = (): boolean => {
    const newErrors: FormErrors = {};
    if (!name.trim() || name.trim().length < 2) {
      newErrors.name = "Name must be at least 2 characters";
    }
    if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      newErrors.email = "Please enter a valid email address";
    }
    if (password.length < 8) {
      newErrors.password = "Password must be at least 8 characters";
    }
    if (password !== confirmPassword) {
      newErrors.confirmPassword = "Passwords do not match";
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    setIsSubmitting(true);
    try {
      await new Promise((res) => setTimeout(res, 600));
      toast.info("Please complete registration with Internet Identity", {
        description: "Click the button below to create your secure account.",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleInternetIdentity = async () => {
    try {
      await login();
      if (name.trim()) {
        saveProfile({
          name: name.trim(),
          email: email.trim() || undefined,
          role: "user",
          bookmarks: [],
        });
      }
      toast.success("Account created! Welcome to Famous Temples of Bharat 🙏");
      navigate({ to: "/dashboard/user" });
    } catch {
      toast.error("Registration failed. Please try again.");
    }
  };

  const passwordStrength = () => {
    if (!password) return null;
    const checks = [
      password.length >= 8,
      /[A-Z]/.test(password),
      /[0-9]/.test(password),
      /[^A-Za-z0-9]/.test(password),
    ];
    const score = checks.filter(Boolean).length;
    if (score <= 1)
      return { label: "Weak", color: "bg-destructive", width: "w-1/4" };
    if (score === 2)
      return { label: "Fair", color: "bg-accent", width: "w-2/4" };
    if (score === 3)
      return { label: "Good", color: "bg-primary", width: "w-3/4" };
    return { label: "Strong", color: "bg-primary", width: "w-full" };
  };

  const strength = passwordStrength();

  return (
    <div className="min-h-[calc(100vh-4rem)] flex items-center justify-center bg-background px-4 py-10">
      <motion.div
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="w-full max-w-md"
      >
        <div className="bg-card border border-border rounded-2xl shadow-warm-lg overflow-hidden">
          <div className="h-2 bg-gradient-to-r from-accent via-primary to-accent" />

          <div className="p-8">
            {/* Logo */}
            <div className="flex flex-col items-center gap-3 mb-8">
              <div className="w-14 h-14 rounded-full bg-primary/10 border border-primary/20 flex items-center justify-center">
                <Flame className="w-8 h-8 text-primary" />
              </div>
              <div className="text-center">
                <h1 className="font-display font-bold text-2xl text-foreground">
                  Create Account
                </h1>
                <p className="text-sm text-muted-foreground mt-1">
                  Join thousands of devotees across Bharat
                </p>
              </div>
            </div>

            {/* Internet Identity */}
            <Button
              type="button"
              onClick={handleInternetIdentity}
              className="w-full btn-accessible bg-primary text-primary-foreground hover:bg-primary/90 gap-2 text-base mb-6"
              data-ocid="btn-register-identity"
            >
              <Fingerprint className="w-5 h-5" />
              Register with Internet Identity
            </Button>

            <div className="flex items-center gap-3 mb-6">
              <Separator className="flex-1" />
              <span className="text-xs text-muted-foreground font-medium">
                or fill in details
              </span>
              <Separator className="flex-1" />
            </div>

            <form
              onSubmit={handleSubmit}
              className="flex flex-col gap-5"
              noValidate
            >
              {/* Name */}
              <div className="flex flex-col gap-2">
                <Label
                  htmlFor="name"
                  className="text-sm font-medium text-foreground"
                >
                  Full Name <span className="text-destructive">*</span>
                </Label>
                <Input
                  id="name"
                  type="text"
                  value={name}
                  onChange={(e) => {
                    setName(e.target.value);
                    if (errors.name)
                      setErrors((p) => ({ ...p, name: undefined }));
                  }}
                  onBlur={() => {
                    if (name && name.trim().length < 2)
                      setErrors((p) => ({
                        ...p,
                        name: "Name must be at least 2 characters",
                      }));
                  }}
                  placeholder="Your full name"
                  autoComplete="name"
                  className={`h-12 text-base focus-ring ${errors.name ? "border-destructive" : ""}`}
                  data-ocid="input-name"
                />
                {errors.name && (
                  <p className="text-xs text-destructive flex items-center gap-1">
                    {errors.name}
                  </p>
                )}
              </div>

              {/* Email */}
              <div className="flex flex-col gap-2">
                <Label
                  htmlFor="email"
                  className="text-sm font-medium text-foreground"
                >
                  Email Address <span className="text-destructive">*</span>
                </Label>
                <Input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value);
                    if (errors.email)
                      setErrors((p) => ({ ...p, email: undefined }));
                  }}
                  onBlur={() => {
                    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
                      setErrors((p) => ({
                        ...p,
                        email: "Please enter a valid email",
                      }));
                  }}
                  placeholder="you@example.com"
                  autoComplete="email"
                  className={`h-12 text-base focus-ring ${errors.email ? "border-destructive" : ""}`}
                  data-ocid="input-email"
                />
                {errors.email && (
                  <p className="text-xs text-destructive">{errors.email}</p>
                )}
              </div>

              {/* Password */}
              <div className="flex flex-col gap-2">
                <Label
                  htmlFor="password"
                  className="text-sm font-medium text-foreground"
                >
                  Password <span className="text-destructive">*</span>
                </Label>
                <div className="relative">
                  <Input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    value={password}
                    onChange={(e) => {
                      setPassword(e.target.value);
                      if (errors.password)
                        setErrors((p) => ({ ...p, password: undefined }));
                    }}
                    placeholder="Min. 8 characters"
                    autoComplete="new-password"
                    className={`h-12 text-base pr-12 focus-ring ${errors.password ? "border-destructive" : ""}`}
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
                {password && strength && (
                  <div className="flex items-center gap-2 mt-1">
                    <div className="flex-1 h-1.5 bg-muted rounded-full overflow-hidden">
                      <div
                        className={`h-full rounded-full transition-all duration-300 ${strength.color} ${strength.width}`}
                      />
                    </div>
                    <span className="text-xs text-muted-foreground">
                      {strength.label}
                    </span>
                  </div>
                )}
                {errors.password && (
                  <p className="text-xs text-destructive">{errors.password}</p>
                )}
              </div>

              {/* Confirm Password */}
              <div className="flex flex-col gap-2">
                <Label
                  htmlFor="confirmPassword"
                  className="text-sm font-medium text-foreground"
                >
                  Confirm Password <span className="text-destructive">*</span>
                </Label>
                <div className="relative">
                  <Input
                    id="confirmPassword"
                    type={showConfirmPassword ? "text" : "password"}
                    value={confirmPassword}
                    onChange={(e) => {
                      setConfirmPassword(e.target.value);
                      if (errors.confirmPassword)
                        setErrors((p) => ({
                          ...p,
                          confirmPassword: undefined,
                        }));
                    }}
                    placeholder="Repeat your password"
                    autoComplete="new-password"
                    className={`h-12 text-base pr-12 focus-ring ${errors.confirmPassword ? "border-destructive" : ""}`}
                    data-ocid="input-confirm-password"
                  />
                  <button
                    type="button"
                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                    aria-label={
                      showConfirmPassword ? "Hide password" : "Show password"
                    }
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground focus-ring rounded p-1"
                  >
                    {showConfirmPassword ? (
                      <EyeOff className="w-5 h-5" />
                    ) : (
                      <Eye className="w-5 h-5" />
                    )}
                  </button>
                  {confirmPassword && confirmPassword === password && (
                    <CheckCircle2 className="absolute right-12 top-1/2 -translate-y-1/2 w-4 h-4 text-primary" />
                  )}
                </div>
                {errors.confirmPassword && (
                  <p className="text-xs text-destructive">
                    {errors.confirmPassword}
                  </p>
                )}
              </div>

              <Button
                type="submit"
                disabled={isSubmitting}
                className="w-full btn-accessible border border-primary/40 text-primary bg-transparent hover:bg-primary/10 gap-2 text-base mt-1"
                variant="outline"
                data-ocid="btn-submit-register"
              >
                {isSubmitting ? (
                  <span className="flex items-center gap-2">
                    <span className="w-4 h-4 border-2 border-primary/30 border-t-primary rounded-full animate-spin" />
                    Creating account...
                  </span>
                ) : (
                  <>
                    <UserPlus className="w-5 h-5" />
                    Create Account
                  </>
                )}
              </Button>
            </form>

            <p className="text-center text-sm text-muted-foreground mt-6">
              Already have an account?{" "}
              <Link
                to="/login"
                className="text-primary font-medium hover:underline focus-ring rounded"
                data-ocid="link-to-login"
              >
                Sign in here
              </Link>
            </p>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
