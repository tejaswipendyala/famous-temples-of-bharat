import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { Link } from "@tanstack/react-router";
import {
  BookmarkX,
  Clock,
  Edit3,
  Eye,
  Flame,
  LayoutDashboard,
  LogOut,
  MapPin,
  Save,
  Search,
  Star,
  User,
  X,
} from "lucide-react";
import { motion } from "motion/react";
import { useEffect, useState } from "react";
import { toast } from "sonner";
import ProtectedRoute from "../components/ProtectedRoute";
import { useAuth } from "../hooks/useAuth";
import { type MappedTempleCard, useTemples } from "../hooks/useTemples";
import { useUserProfile } from "../hooks/useUserProfile";

const VISIT_HISTORY_KEY = "ftob_visit_history";

interface VisitRecord {
  id: string;
  name: string;
  city: string;
  state: string;
  imageUrl: string;
  visitedAt: string;
}

function useVisitHistory() {
  const [history, setHistory] = useState<VisitRecord[]>([]);
  useEffect(() => {
    try {
      const raw = localStorage.getItem(VISIT_HISTORY_KEY);
      if (raw) setHistory(JSON.parse(raw) as VisitRecord[]);
    } catch {
      setHistory([]);
    }
  }, []);
  return history;
}

function StatCard({
  icon,
  label,
  value,
  delay,
}: {
  icon: React.ReactNode;
  label: string;
  value: number | string;
  delay: number;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay, duration: 0.4, ease: "easeOut" }}
    >
      <Card className="bg-card border-border shadow-warm-sm hover:shadow-warm-md transition-smooth">
        <CardContent className="flex items-center gap-4 p-5">
          <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
            {icon}
          </div>
          <div className="min-w-0">
            <p className="text-2xl font-display font-bold text-foreground leading-none">
              {value}
            </p>
            <p className="text-sm text-muted-foreground mt-1 truncate">
              {label}
            </p>
          </div>
        </CardContent>
      </Card>
    </motion.div>
  );
}

function nameToHue(name: string): number {
  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = (hash * 31 + name.charCodeAt(i)) & 0xffffffff;
  }
  return Math.abs(hash) % 360;
}

function BookmarkedTempleCard({
  temple,
  onRemove,
}: {
  temple: {
    id: string;
    name: string;
    deity: string;
    city: string;
    state: string;
    category: string;
    isBookmarked?: boolean;
  };
  onRemove: (id: string) => void;
}) {
  const hue = nameToHue(temple.name);
  const h1 = 30 + (hue % 25);
  const h2 = 55 + (hue % 20);
  return (
    <div className="bg-card border border-border rounded-xl overflow-hidden flex flex-col group hover:shadow-warm-md transition-smooth">
      <div className="relative aspect-[3/2] overflow-hidden">
        <div
          className="w-full h-full flex flex-col items-center justify-center gap-1"
          style={{
            background: `linear-gradient(135deg, oklch(0.55 0.18 ${h1}), oklch(0.42 0.22 ${h2}))`,
          }}
        >
          <span className="text-3xl" role="img" aria-label="temple">
            🛕
          </span>
          <span className="text-xs text-white/75 text-center px-2 line-clamp-1">
            {temple.deity}
          </span>
        </div>
        <button
          onClick={() => onRemove(temple.id)}
          aria-label={`Remove ${temple.name} from saved`}
          className="absolute top-2 right-2 w-8 h-8 flex items-center justify-center rounded-full bg-card/80 backdrop-blur-sm text-muted-foreground hover:text-destructive hover:bg-card transition-smooth shadow-warm-sm focus-ring"
          type="button"
          data-ocid={`remove-bookmark-${temple.id}`}
        >
          <BookmarkX className="w-4 h-4" />
        </button>
        <div className="absolute bottom-2 left-2">
          <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-primary/90 text-primary-foreground">
            {temple.category}
          </span>
        </div>
      </div>
      <div className="p-3 flex flex-col gap-1 flex-1">
        <h4 className="font-display font-semibold text-sm text-foreground line-clamp-1">
          {temple.name}
        </h4>
        <p className="text-xs text-accent font-medium">{temple.deity}</p>
        <div className="flex items-center gap-1 text-xs text-muted-foreground">
          <MapPin className="w-3 h-3 shrink-0" />
          <span className="truncate">
            {temple.city}, {temple.state}
          </span>
        </div>
        <Button
          asChild
          size="sm"
          variant="outline"
          className="mt-2 h-8 text-xs border-primary/30 text-primary hover:bg-primary/10"
          data-ocid={`view-temple-${temple.id}`}
        >
          <Link to="/temples/$id" params={{ id: temple.id }}>
            View Temple
          </Link>
        </Button>
      </div>
    </div>
  );
}

function ProfileSection() {
  const { profile, saveProfile, isLoading } = useUserProfile();
  const { principal } = useAuth();
  const [editing, setEditing] = useState(false);
  const [nameValue, setNameValue] = useState(profile?.name ?? "");

  useEffect(() => {
    setNameValue(profile?.name ?? "");
  }, [profile?.name]);

  const handleSave = () => {
    if (!nameValue.trim()) return;
    saveProfile({ name: nameValue.trim() });
    setEditing(false);
    toast.success("Profile updated", {
      description: "Your name has been saved.",
    });
  };

  const initials = (profile?.name ?? "D")
    .split(" ")
    .map((w) => w[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);

  if (isLoading) {
    return (
      <Card className="bg-card border-border shadow-warm-sm">
        <CardContent className="p-6 flex gap-5 items-center">
          <Skeleton className="w-16 h-16 rounded-full" />
          <div className="flex flex-col gap-2 flex-1">
            <Skeleton className="h-5 w-40 rounded" />
            <Skeleton className="h-4 w-52 rounded" />
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="bg-card border-border shadow-warm-sm">
      <CardHeader className="pb-3">
        <CardTitle className="font-display text-lg flex items-center gap-2">
          <User className="w-5 h-5 text-primary" />
          My Profile
        </CardTitle>
      </CardHeader>
      <CardContent className="flex flex-col sm:flex-row gap-5 items-start sm:items-center">
        <Avatar className="w-16 h-16 shrink-0 border-2 border-primary/30">
          <AvatarFallback className="bg-primary/10 text-primary font-display font-bold text-xl">
            {initials}
          </AvatarFallback>
        </Avatar>
        <div className="flex flex-col gap-2 flex-1 min-w-0 w-full">
          {editing ? (
            <div className="flex flex-col gap-3">
              <div>
                <Label htmlFor="edit-name" className="text-sm font-medium">
                  Display Name
                </Label>
                <div className="flex gap-2 mt-1">
                  <Input
                    id="edit-name"
                    value={nameValue}
                    onChange={(e) => setNameValue(e.target.value)}
                    placeholder="Enter your name"
                    className="h-10 border-input focus:border-primary"
                    data-ocid="profile-name-input"
                    onKeyDown={(e) => {
                      if (e.key === "Enter") handleSave();
                      if (e.key === "Escape") setEditing(false);
                    }}
                    autoFocus
                  />
                  <Button
                    onClick={handleSave}
                    size="sm"
                    className="h-10 px-4 bg-primary text-primary-foreground hover:bg-primary/90"
                    data-ocid="save-profile-btn"
                  >
                    <Save className="w-4 h-4 mr-1" /> Save
                  </Button>
                  <Button
                    onClick={() => setEditing(false)}
                    size="sm"
                    variant="ghost"
                    className="h-10 px-3"
                    aria-label="Cancel edit"
                  >
                    <X className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            </div>
          ) : (
            <div className="flex flex-wrap items-center gap-3">
              <div className="min-w-0">
                <p className="font-display font-semibold text-lg text-foreground truncate">
                  {profile?.name || "Devotee"}
                </p>
                <p className="text-sm text-muted-foreground truncate">
                  {principal?.toString().slice(0, 20)}…
                </p>
                {profile?.role && (
                  <Badge
                    variant="outline"
                    className="mt-1 text-xs border-primary/30 text-primary"
                  >
                    {profile.role === "admin" ? "Admin" : "Devotee"}
                  </Badge>
                )}
              </div>
              <Button
                onClick={() => setEditing(true)}
                size="sm"
                variant="outline"
                className="h-9 px-3 border-border hover:border-primary/50 text-muted-foreground hover:text-primary"
                data-ocid="edit-profile-btn"
              >
                <Edit3 className="w-3.5 h-3.5 mr-1.5" /> Edit Name
              </Button>
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

function DashboardContent() {
  const { logout } = useAuth();
  const { profile } = useUserProfile();
  const visitHistory = useVisitHistory();
  const { allTemples, toggleBookmark } = useTemples();

  // Bookmarked temples: from profile bookmarks
  const bookmarkedIds = new Set(profile?.bookmarks ?? []);
  const savedTemples = allTemples
    .filter((t) => bookmarkedIds.has(t.id))
    .map((t) => ({ ...t, isBookmarked: true }));

  const handleRemoveBookmark = (id: string) => {
    toggleBookmark(id);
    toast.success("Removed from saved temples");
  };

  const greeting = () => {
    const h = new Date().getHours();
    if (h < 12) return "Good Morning";
    if (h < 17) return "Good Afternoon";
    return "Good Evening";
  };

  const displayName = profile?.name || "Devotee";

  return (
    <div className="min-h-screen bg-background">
      {/* Hero greeting banner */}
      <div className="bg-card border-b border-border">
        <div className="container mx-auto px-4 py-8 max-w-5xl">
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4"
          >
            <div>
              <div className="flex items-center gap-2 mb-1">
                <Flame className="w-5 h-5 text-primary" />
                <span className="text-sm font-medium text-primary uppercase tracking-widest">
                  My Dashboard
                </span>
              </div>
              <h1 className="font-display text-3xl sm:text-4xl font-bold text-foreground leading-tight">
                {greeting()}, {displayName} 🙏
              </h1>
              <p className="text-muted-foreground mt-1 text-base">
                May your journey through the sacred temples of Bharat be filled
                with peace and blessings.
              </p>
            </div>
            <div className="flex items-center gap-3 shrink-0">
              <Button
                asChild
                variant="outline"
                className="h-11 px-5 border-primary/30 text-primary hover:bg-primary/10 font-medium"
                data-ocid="explore-temples-nav-btn"
              >
                <Link
                  to="/temples"
                  search={{ q: "", nearby: "", state: "", category: "" }}
                >
                  <Search className="w-4 h-4 mr-2" />
                  Explore Temples
                </Link>
              </Button>
              <Button
                onClick={logout}
                variant="ghost"
                className="h-11 px-4 text-muted-foreground hover:text-destructive hover:bg-destructive/10"
                data-ocid="logout-btn"
              >
                <LogOut className="w-4 h-4 mr-2" />
                Logout
              </Button>
            </div>
          </motion.div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8 max-w-5xl space-y-10">
        {/* Quick Stats */}
        <section aria-label="Quick stats">
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <StatCard
              icon={<LayoutDashboard className="w-5 h-5 text-primary" />}
              label="Temples Saved"
              value={savedTemples.length}
              delay={0}
            />
            <StatCard
              icon={<Eye className="w-5 h-5 text-primary" />}
              label="Recently Viewed"
              value={visitHistory.length}
              delay={0.08}
            />
            <StatCard
              icon={<Star className="w-5 h-5 text-primary" />}
              label="Reviews Written"
              value={0}
              delay={0.16}
            />
            <StatCard
              icon={<MapPin className="w-5 h-5 text-primary" />}
              label="States Explored"
              value={new Set(savedTemples.map((t) => t.state)).size || 0}
              delay={0.24}
            />
          </div>
        </section>

        <Separator className="bg-border" />

        {/* Profile */}
        <motion.section
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          aria-label="Profile"
        >
          <ProfileSection />
        </motion.section>

        <Separator className="bg-border" />

        {/* Saved Temples */}
        <motion.section
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          aria-label="Saved Temples"
        >
          <div className="flex items-center justify-between mb-5">
            <div>
              <h2 className="font-display text-2xl font-bold text-foreground">
                Saved Temples
              </h2>
              <p className="text-sm text-muted-foreground mt-0.5">
                Your personal collection of sacred places
              </p>
            </div>
            {savedTemples.length > 0 && (
              <Badge
                variant="outline"
                className="border-primary/30 text-primary text-sm px-3 py-1"
              >
                {savedTemples.length} saved
              </Badge>
            )}
          </div>

          {savedTemples.length === 0 ? (
            <div
              className="bg-muted/40 border border-border rounded-2xl flex flex-col items-center justify-center py-16 px-6 text-center"
              data-ocid="saved-temples-empty"
            >
              <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mb-4">
                <Flame className="w-8 h-8 text-primary/60" />
              </div>
              <h3 className="font-display text-xl font-semibold text-foreground mb-2">
                No temples saved yet
              </h3>
              <p className="text-muted-foreground text-sm mb-6 max-w-xs">
                Start your spiritual journey by exploring temples across Bharat
                and bookmarking the ones you wish to visit.
              </p>
              <Button
                asChild
                className="h-12 px-8 text-base bg-primary text-primary-foreground hover:bg-primary/90"
                data-ocid="explore-temples-empty-cta"
              >
                <Link
                  to="/temples"
                  search={{ q: "", nearby: "", state: "", category: "" }}
                >
                  <Search className="w-4 h-4 mr-2" />
                  Explore Temples
                </Link>
              </Button>
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
              {savedTemples.map((temple, i) => (
                <motion.div
                  key={temple.id}
                  initial={{ opacity: 0, scale: 0.95 }}
                  whileInView={{ opacity: 1, scale: 1 }}
                  viewport={{ once: true }}
                  transition={{ delay: i * 0.07, duration: 0.3 }}
                >
                  <BookmarkedTempleCard
                    temple={temple}
                    onRemove={handleRemoveBookmark}
                  />
                </motion.div>
              ))}
            </div>
          )}
        </motion.section>

        <Separator className="bg-border" />

        {/* Visit History */}
        <motion.section
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          aria-label="Visit History"
        >
          <div className="flex items-center justify-between mb-5">
            <div>
              <h2 className="font-display text-2xl font-bold text-foreground">
                Recently Viewed
              </h2>
              <p className="text-sm text-muted-foreground mt-0.5">
                Temples you've explored on this device
              </p>
            </div>
          </div>

          {visitHistory.length === 0 ? (
            <div
              className="bg-muted/40 border border-border rounded-xl flex items-center gap-4 p-6"
              data-ocid="visit-history-empty"
            >
              <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                <Clock className="w-6 h-6 text-primary/60" />
              </div>
              <div>
                <p className="font-medium text-foreground">
                  No recent visits yet
                </p>
                <p className="text-sm text-muted-foreground">
                  When you view temple details, they'll appear here.
                </p>
              </div>
            </div>
          ) : (
            <div className="flex flex-col gap-3">
              {visitHistory.slice(0, 8).map((record, i) => (
                <motion.div
                  key={`${record.id}-${record.visitedAt}`}
                  initial={{ opacity: 0, x: -12 }}
                  whileInView={{ opacity: 1, x: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: i * 0.06, duration: 0.3 }}
                  className="bg-card border border-border rounded-xl overflow-hidden flex gap-0 hover:shadow-warm-sm transition-smooth group"
                  data-ocid={`visit-history-${record.id}`}
                >
                  <div className="w-20 sm:w-28 shrink-0 overflow-hidden">
                    {record.imageUrl ? (
                      <img
                        src={record.imageUrl}
                        alt={record.name}
                        className="w-full h-full object-cover group-hover:scale-105 transition-smooth"
                        loading="lazy"
                      />
                    ) : (
                      <div
                        className="w-full h-full flex items-center justify-center text-2xl min-h-[72px]"
                        style={{
                          background: `linear-gradient(135deg, oklch(0.55 0.18 ${30 + (nameToHue(record.name) % 25)}), oklch(0.42 0.22 ${55 + (nameToHue(record.name) % 20)}))`,
                        }}
                      >
                        🛕
                      </div>
                    )}
                  </div>
                  <div className="flex flex-col justify-center px-4 py-3 gap-0.5 flex-1 min-w-0">
                    <p className="font-display font-semibold text-sm text-foreground truncate">
                      {record.name}
                    </p>
                    <div className="flex items-center gap-1 text-xs text-muted-foreground">
                      <MapPin className="w-3 h-3 shrink-0" />
                      <span className="truncate">
                        {record.city}, {record.state}
                      </span>
                    </div>
                    <div className="flex items-center gap-1 text-xs text-muted-foreground mt-0.5">
                      <Clock className="w-3 h-3 shrink-0" />
                      <span>
                        Viewed{" "}
                        {new Date(record.visitedAt).toLocaleDateString(
                          "en-IN",
                          {
                            day: "numeric",
                            month: "short",
                            year: "numeric",
                          },
                        )}
                      </span>
                    </div>
                  </div>
                  <div className="flex items-center pr-4">
                    <Button
                      asChild
                      size="sm"
                      variant="ghost"
                      className="h-9 px-3 text-xs text-primary hover:bg-primary/10"
                    >
                      <Link to="/temples/$id" params={{ id: record.id }}>
                        View
                      </Link>
                    </Button>
                  </div>
                </motion.div>
              ))}
            </div>
          )}
        </motion.section>
      </div>
    </div>
  );
}

export default function UserDashboardPage() {
  return (
    <ProtectedRoute>
      <DashboardContent />
    </ProtectedRoute>
  );
}
