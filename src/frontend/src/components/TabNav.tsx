import { cn } from "@/lib/utils";

export interface TabItem {
  id: string;
  label: string;
  icon?: React.ReactNode;
}

interface TabNavProps {
  tabs: TabItem[];
  active: string;
  onChange: (id: string) => void;
  className?: string;
}

export default function TabNav({
  tabs,
  active,
  onChange,
  className,
}: TabNavProps) {
  return (
    <div
      className={cn(
        "flex overflow-x-auto scrollbar-none border-b border-border bg-card",
        className,
      )}
      role="tablist"
      aria-label="Temple information tabs"
    >
      {tabs.map((tab) => (
        <button
          key={tab.id}
          type="button"
          role="tab"
          aria-selected={active === tab.id}
          aria-controls={`tabpanel-${tab.id}`}
          onClick={() => onChange(tab.id)}
          data-ocid={`tab-${tab.id}`}
          className={cn(
            "flex items-center gap-1.5 px-4 py-3.5 text-sm font-medium whitespace-nowrap border-b-2 transition-smooth focus-ring min-h-[48px] shrink-0",
            active === tab.id
              ? "border-primary text-primary"
              : "border-transparent text-muted-foreground hover:text-foreground hover:border-border",
          )}
        >
          {tab.icon && <span className="w-4 h-4">{tab.icon}</span>}
          {tab.label}
        </button>
      ))}
    </div>
  );
}
