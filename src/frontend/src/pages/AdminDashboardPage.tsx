import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { useActor } from "@caffeineai/core-infrastructure";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  AlertTriangle,
  BarChart3,
  Building2,
  HelpCircle,
  LayoutDashboard,
  Pencil,
  PlusCircle,
  ShieldCheck,
  Trash2,
  Users,
} from "lucide-react";
import { motion } from "motion/react";
import { useState } from "react";
import { toast } from "sonner";
import { createActor } from "../backend";
import type {
  Temple,
  TempleInput,
  UserSummary,
  backendInterface,
} from "../backend.d";
import { UserRole } from "../backend.d";
import FAQManager from "../components/FAQManager";
import ProtectedRoute from "../components/ProtectedRoute";
import TempleForm from "../components/TempleForm";

// ─── Types ─────────────────────────────────────────────────────────────────
type NavSection = "overview" | "temples" | "faqs" | "users";

// ─── Sidebar ───────────────────────────────────────────────────────────────
interface SidebarProps {
  active: NavSection;
  onChange: (s: NavSection) => void;
}

const NAV_ITEMS: { id: NavSection; label: string; icon: React.ReactNode }[] = [
  {
    id: "overview",
    label: "Overview",
    icon: <LayoutDashboard className="w-5 h-5" />,
  },
  {
    id: "temples",
    label: "Manage Temples",
    icon: <Building2 className="w-5 h-5" />,
  },
  {
    id: "faqs",
    label: "Manage FAQs",
    icon: <HelpCircle className="w-5 h-5" />,
  },
  { id: "users", label: "Manage Users", icon: <Users className="w-5 h-5" /> },
];

function Sidebar({ active, onChange }: SidebarProps) {
  return (
    <nav
      className="hidden lg:flex flex-col bg-card border-r border-border w-56 shrink-0 py-6 gap-1"
      aria-label="Admin navigation"
      data-ocid="admin-sidebar"
    >
      <div className="px-4 pb-4 flex items-center gap-2">
        <ShieldCheck className="w-5 h-5 text-primary" />
        <span className="font-display font-semibold text-sm text-foreground">
          Admin Panel
        </span>
      </div>
      <Separator className="mb-2" />
      {NAV_ITEMS.map((item) => (
        <button
          type="button"
          key={item.id}
          onClick={() => onChange(item.id)}
          className={`flex items-center gap-3 px-4 py-3 text-sm font-medium rounded-lg mx-2 transition-smooth ${
            active === item.id
              ? "bg-primary/10 text-primary"
              : "text-muted-foreground hover:bg-muted hover:text-foreground"
          }`}
          data-ocid={`admin-nav-${item.id}`}
        >
          {item.icon}
          {item.label}
        </button>
      ))}
    </nav>
  );
}

// ─── Stat Card ─────────────────────────────────────────────────────────────
interface StatCardProps {
  icon: React.ReactNode;
  label: string;
  value: number | string;
  color?: string;
}
function StatCard({
  icon,
  label,
  value,
  color = "text-primary",
}: StatCardProps) {
  return (
    <div className="bg-card border border-border rounded-xl p-5 flex items-center gap-4 shadow-warm-sm">
      <div
        className={`w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center ${color}`}
      >
        {icon}
      </div>
      <div>
        <p className="text-2xl font-display font-bold text-foreground">
          {value}
        </p>
        <p className="text-sm text-muted-foreground">{label}</p>
      </div>
    </div>
  );
}

// ─── Overview Section ──────────────────────────────────────────────────────
interface OverviewProps {
  temples: Temple[];
  users: UserSummary[];
}
function OverviewSection({ temples, users }: OverviewProps) {
  const totalFaqs = 0; // aggregated async; use placeholder
  return (
    <div className="flex flex-col gap-6" data-ocid="admin-overview">
      <div>
        <h2 className="font-display font-bold text-2xl text-foreground mb-1">
          Overview
        </h2>
        <p className="text-muted-foreground text-sm">
          A quick glance at your platform's content and activity.
        </p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          <StatCard
            icon={<Building2 className="w-6 h-6" />}
            label="Total Temples"
            value={temples.length}
          />
        </motion.div>
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: 0.08 }}
        >
          <StatCard
            icon={<Users className="w-6 h-6" />}
            label="Registered Users"
            value={users.length}
            color="text-accent"
          />
        </motion.div>
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, delay: 0.16 }}
        >
          <StatCard
            icon={<HelpCircle className="w-6 h-6" />}
            label="Total FAQs"
            value={totalFaqs}
            color="text-muted-foreground"
          />
        </motion.div>
      </div>

      {/* Recent temples */}
      <div>
        <h3 className="font-display font-semibold text-base text-foreground mb-3">
          Recently Added Temples
        </h3>
        {temples.length === 0 ? (
          <p className="text-muted-foreground text-sm">No temples added yet.</p>
        ) : (
          <div className="flex flex-col gap-2">
            {temples.slice(0, 5).map((t) => (
              <div
                key={String(t.id)}
                className="flex items-center justify-between bg-card border border-border rounded-xl px-4 py-3"
              >
                <div className="min-w-0">
                  <p className="font-medium text-foreground text-sm truncate">
                    {t.name}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    {t.city}, {t.state}
                  </p>
                </div>
                <Badge variant="secondary" className="ml-4 shrink-0 text-xs">
                  {t.deity}
                </Badge>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

// ─── Temples Section ───────────────────────────────────────────────────────
interface TemplesSectionProps {
  temples: Temple[];
  isLoading: boolean;
  onRefresh: () => void;
}

function TemplesSection({
  temples,
  isLoading,
  onRefresh,
}: TemplesSectionProps) {
  const { actor: rawActor } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  const [showForm, setShowForm] = useState(false);
  const [editTemple, setEditTemple] = useState<Temple | null>(null);

  const addMutation = useMutation({
    mutationFn: async (input: TempleInput) => {
      if (!actor) throw new Error("No actor");
      return actor.addTemple(input);
    },
    onSuccess: () => {
      toast.success("Temple added successfully!");
      setShowForm(false);
      onRefresh();
    },
    onError: () => toast.error("Failed to add temple"),
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, input }: { id: bigint; input: TempleInput }) => {
      if (!actor) throw new Error("No actor");
      return actor.updateTemple(id, input);
    },
    onSuccess: () => {
      toast.success("Temple updated!");
      setEditTemple(null);
      onRefresh();
    },
    onError: () => toast.error("Failed to update temple"),
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: bigint) => {
      if (!actor) throw new Error("No actor");
      return actor.deleteTemple(id);
    },
    onSuccess: () => {
      toast.success("Temple deleted");
      onRefresh();
    },
    onError: () => toast.error("Failed to delete temple"),
  });

  return (
    <div className="flex flex-col gap-6" data-ocid="admin-temples">
      <div className="flex items-start justify-between gap-4">
        <div>
          <h2 className="font-display font-bold text-2xl text-foreground mb-1">
            Manage Temples
          </h2>
          <p className="text-muted-foreground text-sm">
            Add, edit, or remove temple listings.
          </p>
        </div>
        <Button
          type="button"
          className="bg-primary text-primary-foreground hover:bg-primary/90 btn-accessible gap-2 shrink-0"
          onClick={() => {
            setEditTemple(null);
            setShowForm(true);
          }}
          data-ocid="admin-add-temple-btn"
        >
          <PlusCircle className="w-5 h-5" /> Add Temple
        </Button>
      </div>

      {/* Table */}
      {isLoading ? (
        <div className="flex flex-col gap-3">
          {[1, 2, 3, 4].map((n) => (
            <Skeleton key={n} className="h-14 w-full rounded-xl" />
          ))}
        </div>
      ) : temples.length === 0 ? (
        <div
          className="flex flex-col items-center gap-4 py-16 text-center"
          data-ocid="temples-empty"
        >
          <Building2 className="w-12 h-12 text-muted-foreground/30" />
          <p className="text-muted-foreground">No temples yet.</p>
          <Button
            type="button"
            onClick={() => setShowForm(true)}
            className="bg-primary text-primary-foreground hover:bg-primary/90 gap-2"
          >
            <PlusCircle className="w-4 h-4" /> Add First Temple
          </Button>
        </div>
      ) : (
        <div className="overflow-x-auto rounded-xl border border-border">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-muted/50 text-left">
                <th className="px-4 py-3 font-semibold text-foreground">
                  Name
                </th>
                <th className="px-4 py-3 font-semibold text-foreground hidden sm:table-cell">
                  Deity
                </th>
                <th className="px-4 py-3 font-semibold text-foreground hidden md:table-cell">
                  City
                </th>
                <th className="px-4 py-3 font-semibold text-foreground hidden lg:table-cell">
                  State
                </th>
                <th className="px-4 py-3 font-semibold text-foreground text-right">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody>
              {temples.map((t) => (
                <tr
                  key={String(t.id)}
                  className="border-t border-border hover:bg-muted/30 transition-colors"
                  data-ocid={`temple-row-${t.id}`}
                >
                  <td className="px-4 py-3 text-foreground font-medium max-w-[160px] truncate">
                    {t.name}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground hidden sm:table-cell">
                    {t.deity}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground hidden md:table-cell">
                    {t.city}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground hidden lg:table-cell">
                    {t.state}
                  </td>
                  <td className="px-4 py-3 text-right">
                    <div className="flex items-center justify-end gap-1">
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        className="h-8 w-8 p-0"
                        onClick={() => {
                          setEditTemple(t);
                          setShowForm(true);
                        }}
                        aria-label={`Edit ${t.name}`}
                        data-ocid={`temple-edit-${t.id}`}
                      >
                        <Pencil className="w-4 h-4" />
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        className="h-8 w-8 p-0 text-destructive hover:text-destructive"
                        onClick={() => deleteMutation.mutate(t.id)}
                        disabled={deleteMutation.isPending}
                        aria-label={`Delete ${t.name}`}
                        data-ocid={`temple-delete-${t.id}`}
                      >
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Add / Edit Dialog */}
      <Dialog
        open={showForm}
        onOpenChange={(o) => {
          if (!o) {
            setShowForm(false);
            setEditTemple(null);
          }
        }}
      >
        <DialogContent className="max-w-3xl w-full p-0 overflow-hidden">
          <DialogHeader className="px-6 pt-6 pb-2">
            <DialogTitle className="font-display font-bold text-xl">
              {editTemple ? "Edit Temple" : "Add New Temple"}
            </DialogTitle>
          </DialogHeader>
          <ScrollArea className="max-h-[80vh]">
            <div className="px-6 pb-6">
              <TempleForm
                key={editTemple ? String(editTemple.id) : "new"}
                initial={editTemple ?? undefined}
                onSubmit={(input) => {
                  if (editTemple) {
                    updateMutation.mutate({ id: editTemple.id, input });
                  } else {
                    addMutation.mutate(input);
                  }
                }}
                onCancel={() => {
                  setShowForm(false);
                  setEditTemple(null);
                }}
                isLoading={addMutation.isPending || updateMutation.isPending}
              />
            </div>
          </ScrollArea>
        </DialogContent>
      </Dialog>
    </div>
  );
}

// ─── FAQs Section ──────────────────────────────────────────────────────────
interface FAQsSectionProps {
  temples: Temple[];
}
function FAQsSection({ temples }: FAQsSectionProps) {
  const [selectedTempleId, setSelectedTempleId] = useState<string>("");

  const selectedTemple = temples.find((t) => String(t.id) === selectedTempleId);

  return (
    <div className="flex flex-col gap-6" data-ocid="admin-faqs">
      <div>
        <h2 className="font-display font-bold text-2xl text-foreground mb-1">
          Manage FAQs
        </h2>
        <p className="text-muted-foreground text-sm">
          Select a temple to view and manage its FAQs.
        </p>
      </div>

      <div className="max-w-sm">
        <Select
          value={selectedTempleId}
          onValueChange={setSelectedTempleId}
          data-ocid="faq-temple-select"
        >
          <SelectTrigger className="w-full">
            <SelectValue placeholder="Select a temple…" />
          </SelectTrigger>
          <SelectContent>
            {temples.map((t) => (
              <SelectItem key={String(t.id)} value={String(t.id)}>
                {t.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {selectedTemple ? (
        <FAQManager
          templeId={selectedTemple.id}
          templeName={selectedTemple.name}
        />
      ) : (
        <div
          className="flex flex-col items-center gap-4 py-16 text-center"
          data-ocid="faq-select-empty"
        >
          <HelpCircle className="w-12 h-12 text-muted-foreground/30" />
          <p className="text-muted-foreground">
            {temples.length === 0
              ? "Add a temple first before managing FAQs."
              : "Select a temple above to manage its FAQs."}
          </p>
        </div>
      )}
    </div>
  );
}

// ─── Users Section ─────────────────────────────────────────────────────────
interface UsersSectionProps {
  users: UserSummary[];
  isLoading: boolean;
}

function UsersSection({ users, isLoading }: UsersSectionProps) {
  const { actor: rawActor } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  const qc = useQueryClient();

  const roleMutation = useMutation({
    mutationFn: async ({
      principal,
      role,
    }: {
      principal: UserSummary["principal"];
      role: UserRole;
    }) => {
      if (!actor) throw new Error("No actor");
      return actor.setUserRole(principal, role);
    },
    onSuccess: () => {
      toast.success("User role updated");
      qc.invalidateQueries({ queryKey: ["admin-users"] });
    },
    onError: () => toast.error("Failed to update user role"),
  });

  if (isLoading) {
    return (
      <div className="flex flex-col gap-3">
        {[1, 2, 3].map((n) => (
          <Skeleton key={n} className="h-14 w-full rounded-xl" />
        ))}
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6" data-ocid="admin-users">
      <div>
        <h2 className="font-display font-bold text-2xl text-foreground mb-1">
          Manage Users
        </h2>
        <p className="text-muted-foreground text-sm">
          View registered users and update their roles.
        </p>
      </div>

      {users.length === 0 ? (
        <div
          className="flex flex-col items-center gap-4 py-16 text-center"
          data-ocid="users-empty"
        >
          <Users className="w-12 h-12 text-muted-foreground/30" />
          <p className="text-muted-foreground">No registered users yet.</p>
        </div>
      ) : (
        <div className="overflow-x-auto rounded-xl border border-border">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-muted/50 text-left">
                <th className="px-4 py-3 font-semibold text-foreground">
                  Name
                </th>
                <th className="px-4 py-3 font-semibold text-foreground hidden sm:table-cell">
                  Email
                </th>
                <th className="px-4 py-3 font-semibold text-foreground">
                  Role
                </th>
                <th className="px-4 py-3 font-semibold text-foreground text-right">
                  Change Role
                </th>
              </tr>
            </thead>
            <tbody>
              {users.map((u) => {
                const isAdmin = u.role === UserRole.admin;
                return (
                  <tr
                    key={String(u.principal)}
                    className="border-t border-border hover:bg-muted/30 transition-colors"
                    data-ocid={`user-row-${u.principal}`}
                  >
                    <td className="px-4 py-3 font-medium text-foreground truncate max-w-[120px]">
                      {u.name || "—"}
                    </td>
                    <td className="px-4 py-3 text-muted-foreground hidden sm:table-cell truncate max-w-[200px]">
                      {u.email || "—"}
                    </td>
                    <td className="px-4 py-3">
                      <Badge
                        variant={isAdmin ? "default" : "secondary"}
                        className="capitalize"
                      >
                        {u.role}
                      </Badge>
                    </td>
                    <td className="px-4 py-3 text-right">
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        disabled={roleMutation.isPending}
                        onClick={() =>
                          roleMutation.mutate({
                            principal: u.principal,
                            role: isAdmin ? UserRole.user : UserRole.admin,
                          })
                        }
                        className="text-xs h-8"
                        data-ocid={`user-role-toggle-${u.principal}`}
                      >
                        {isAdmin ? "Set as User" : "Set as Admin"}
                      </Button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

// ─── Access Denied ─────────────────────────────────────────────────────────
function AccessDenied() {
  return (
    <div
      className="flex flex-col items-center justify-center min-h-[60vh] gap-6 text-center px-4"
      data-ocid="admin-access-denied"
    >
      <div className="w-16 h-16 rounded-full bg-destructive/10 flex items-center justify-center">
        <AlertTriangle className="w-8 h-8 text-destructive" />
      </div>
      <h2 className="font-display font-bold text-2xl text-foreground">
        Access Denied
      </h2>
      <p className="text-muted-foreground max-w-sm">
        You need admin privileges to access this page. Please contact an
        existing admin to grant you access.
      </p>
      <Button asChild variant="outline" className="btn-accessible">
        <a href="/">Return Home</a>
      </Button>
    </div>
  );
}

// ─── Main Dashboard ─────────────────────────────────────────────────────────
function AdminDashboardInner() {
  const { actor: rawActor, isFetching: actorLoading } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  const [activeSection, setActiveSection] = useState<NavSection>("overview");

  const { data: isAdminRole, isLoading: checkingAdmin } = useQuery<boolean>({
    queryKey: ["admin-check"],
    queryFn: async () => {
      if (!actor) return false;
      return actor.isCallerAdmin();
    },
    enabled: !!actor && !actorLoading,
  });

  const {
    data: temples = [],
    isLoading: templesLoading,
    refetch: refetchTemples,
  } = useQuery<Temple[]>({
    queryKey: ["admin-temples"],
    queryFn: async () => {
      if (!actor) return [];
      return actor.getAllTemples();
    },
    enabled: !!actor && !actorLoading && !!isAdminRole,
  });

  const { data: users = [], isLoading: usersLoading } = useQuery<UserSummary[]>(
    {
      queryKey: ["admin-users"],
      queryFn: async () => {
        if (!actor) return [];
        return actor.getUsers();
      },
      enabled: !!actor && !actorLoading && !!isAdminRole,
    },
  );

  if (checkingAdmin || actorLoading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="flex flex-col items-center gap-4">
          <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center animate-pulse">
            <BarChart3 className="w-5 h-5 text-primary" />
          </div>
          <p className="text-muted-foreground text-sm">
            Verifying admin access…
          </p>
        </div>
      </div>
    );
  }

  if (!isAdminRole) {
    return <AccessDenied />;
  }

  const renderSection = () => {
    switch (activeSection) {
      case "overview":
        return <OverviewSection temples={temples} users={users} />;
      case "temples":
        return (
          <TemplesSection
            temples={temples}
            isLoading={templesLoading}
            onRefresh={() => refetchTemples()}
          />
        );
      case "faqs":
        return <FAQsSection temples={temples} />;
      case "users":
        return <UsersSection users={users} isLoading={usersLoading} />;
    }
  };

  return (
    <div
      className="flex min-h-screen bg-background"
      data-ocid="admin-dashboard"
    >
      <Sidebar active={activeSection} onChange={setActiveSection} />

      <div className="flex-1 flex flex-col min-w-0">
        {/* Mobile top nav */}
        <div className="lg:hidden flex items-center gap-1 overflow-x-auto bg-card border-b border-border px-3 py-2">
          {NAV_ITEMS.map((item) => (
            <button
              type="button"
              key={item.id}
              onClick={() => setActiveSection(item.id)}
              className={`flex items-center gap-1.5 px-3 py-2 rounded-lg text-xs font-medium whitespace-nowrap transition-smooth ${
                activeSection === item.id
                  ? "bg-primary/10 text-primary"
                  : "text-muted-foreground hover:bg-muted"
              }`}
              data-ocid={`admin-mobile-nav-${item.id}`}
            >
              {item.icon}
              {item.label}
            </button>
          ))}
        </div>

        {/* Content */}
        <main className="flex-1 px-6 py-8 max-w-5xl w-full mx-auto">
          <motion.div
            key={activeSection}
            initial={{ opacity: 0, x: 12 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.3 }}
          >
            {renderSection()}
          </motion.div>
        </main>
      </div>
    </div>
  );
}

export default function AdminDashboardPage() {
  return (
    <ProtectedRoute requireAdmin>
      <AdminDashboardInner />
    </ProtectedRoute>
  );
}
