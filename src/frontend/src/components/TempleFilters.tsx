import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { SlidersHorizontal, X } from "lucide-react";
import type { SearchFilters, TempleCategory } from "../types";

const POPULAR_STATES = [
  "Rajasthan",
  "Tamil Nadu",
  "Uttar Pradesh",
  "Gujarat",
  "Maharashtra",
  "Uttarakhand",
  "Kerala",
];

const ALL_STATES = [
  "Andhra Pradesh",
  "Assam",
  "Bihar",
  "Goa",
  "Gujarat",
  "Himachal Pradesh",
  "Jammu & Kashmir",
  "Karnataka",
  "Kerala",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Odisha",
  "Rajasthan",
  "Tamil Nadu",
  "Telangana",
  "Uttarakhand",
  "Uttar Pradesh",
  "West Bengal",
];

const CATEGORIES: TempleCategory[] = [
  "UNESCO Heritage",
  "Jyotirlinga",
  "Shakti Peetha",
  "Char Dham",
  "Pancha Bhuta Stalagam",
  "Divya Desam",
  "Heritage",
];

const SORT_OPTIONS = [
  { value: "name", label: "Name (A–Z)" },
  { value: "state", label: "By State" },
  { value: "rating", label: "Most Visited" },
];

interface TempleFiltersProps {
  filters: SearchFilters;
  onFiltersChange: (filters: Partial<SearchFilters>) => void;
  onClearAll: () => void;
  totalResults: number;
}

function activeFilterCount(filters: SearchFilters): number {
  let count = 0;
  if (filters.state) count++;
  if (filters.category) count++;
  return count;
}

export default function TempleFilters({
  filters,
  onFiltersChange,
  onClearAll,
  totalResults,
}: TempleFiltersProps) {
  const filtersActive = activeFilterCount(filters);

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <SlidersHorizontal className="w-4 h-4 text-primary" />
          <span className="font-display font-semibold text-sm text-foreground">
            Filters
          </span>
          {filtersActive > 0 && (
            <Badge
              variant="secondary"
              className="text-xs h-5 px-1.5 bg-primary/15 text-primary border-primary/20"
            >
              {filtersActive}
            </Badge>
          )}
        </div>
        {filtersActive > 0 && (
          <Button
            variant="ghost"
            size="sm"
            onClick={onClearAll}
            className="h-7 text-xs text-muted-foreground hover:text-foreground px-2"
            data-ocid="filter-clear-all"
          >
            Clear all
          </Button>
        )}
      </div>

      {/* Results count */}
      <p className="text-xs text-muted-foreground">
        <span className="font-semibold text-foreground">{totalResults}</span>{" "}
        temple{totalResults !== 1 ? "s" : ""} found
      </p>

      {/* Popular state chips */}
      <div>
        <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
          Popular States
        </p>
        <div className="flex flex-wrap gap-2" data-ocid="state-chips">
          {POPULAR_STATES.map((state) => (
            <button
              key={state}
              type="button"
              onClick={() =>
                onFiltersChange({
                  state: filters.state === state ? undefined : state,
                })
              }
              className={`text-xs font-medium px-3 py-1.5 rounded-full border transition-smooth min-h-[32px] ${
                filters.state === state
                  ? "bg-primary text-primary-foreground border-primary"
                  : "bg-card text-foreground border-border hover:border-primary/50 hover:bg-primary/5"
              }`}
              data-ocid={`chip-state-${state.replace(/\s+/g, "-").toLowerCase()}`}
            >
              {state}
            </button>
          ))}
        </div>
      </div>

      {/* State dropdown */}
      <div>
        <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
          Filter by State
        </p>
        <Select
          value={filters.state ?? ""}
          onValueChange={(val) =>
            onFiltersChange({ state: val === "all" ? undefined : val })
          }
        >
          <SelectTrigger
            className="h-11 text-sm border-border bg-card"
            data-ocid="filter-state"
          >
            <SelectValue placeholder="All States" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All States</SelectItem>
            {ALL_STATES.map((s) => (
              <SelectItem key={s} value={s}>
                {s}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        {filters.state && (
          <button
            type="button"
            onClick={() => onFiltersChange({ state: undefined })}
            className="mt-1.5 flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground"
            data-ocid="clear-state-filter"
          >
            <X className="w-3 h-3" /> Clear state
          </button>
        )}
      </div>

      {/* Category filter */}
      <div>
        <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
          Temple Type
        </p>
        <Select
          value={filters.category ?? ""}
          onValueChange={(val) =>
            onFiltersChange({
              category: val === "all" ? undefined : (val as TempleCategory),
            })
          }
        >
          <SelectTrigger
            className="h-11 text-sm border-border bg-card"
            data-ocid="filter-category"
          >
            <SelectValue placeholder="All Categories" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Categories</SelectItem>
            {CATEGORIES.map((c) => (
              <SelectItem key={c} value={c}>
                {c}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        {filters.category && (
          <button
            type="button"
            onClick={() => onFiltersChange({ category: undefined })}
            className="mt-1.5 flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground"
            data-ocid="clear-category-filter"
          >
            <X className="w-3 h-3" /> Clear category
          </button>
        )}
      </div>

      {/* Sort */}
      <div>
        <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
          Sort By
        </p>
        <Select
          value={filters.sortBy ?? "name"}
          onValueChange={(val) =>
            onFiltersChange({ sortBy: val as SearchFilters["sortBy"] })
          }
        >
          <SelectTrigger
            className="h-11 text-sm border-border bg-card"
            data-ocid="filter-sort"
          >
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {SORT_OPTIONS.map((opt) => (
              <SelectItem key={opt.value} value={opt.value}>
                {opt.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
    </div>
  );
}
