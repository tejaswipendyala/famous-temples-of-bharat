import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet";
import { useNavigate, useSearch } from "@tanstack/react-router";
import {
  LayoutGrid,
  List,
  Search,
  SlidersHorizontal,
  Sparkles,
} from "lucide-react";
import { AnimatePresence, motion } from "motion/react";
import { useCallback, useEffect, useRef, useState } from "react";
import SearchBar from "../components/SearchBar";
import SkeletonCard from "../components/SkeletonCard";
import TempleCard from "../components/TempleCard";
import TempleFilters from "../components/TempleFilters";
import { useTemples } from "../hooks/useTemples";
import type { SearchFilters } from "../types";

const PAGE_SIZE = 9;

function EmptyState({ query }: { query: string }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      className="flex flex-col items-center justify-center py-20 px-6 text-center"
      data-ocid="empty-state"
    >
      <div className="w-24 h-24 rounded-full bg-muted/50 flex items-center justify-center mb-6">
        <span className="text-5xl" role="img" aria-label="temple">
          🛕
        </span>
      </div>
      <h3 className="font-display text-xl font-semibold text-foreground mb-2">
        No temples found
      </h3>
      <p className="text-muted-foreground text-sm max-w-xs leading-relaxed">
        {query
          ? `We couldn't find any temples matching "${query}". Try a different keyword or clear your filters.`
          : "No temples match your current filters. Try adjusting or clearing them."}
      </p>
    </motion.div>
  );
}

export default function TemplesSearchPage() {
  const search = useSearch({ from: "/temples" });
  const navigate = useNavigate({ from: "/temples" });

  // Local input state for debouncing
  const [inputValue, setInputValue] = useState(search.q ?? "");
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const [page, setPage] = useState(1);
  const [viewMode, setViewMode] = useState<"grid" | "list">("grid");

  const [filters, setFilters] = useState<SearchFilters>({
    query: search.q ?? "",
    state: search.state ?? undefined,
    category: search.category
      ? (search.category as SearchFilters["category"])
      : undefined,
    sortBy: "name",
  });

  // Sync URL → filters on initial load
  useEffect(() => {
    setFilters((prev) => ({
      ...prev,
      query: search.q ?? "",
      state: search.state ?? undefined,
      category: search.category
        ? (search.category as SearchFilters["category"])
        : undefined,
    }));
    setInputValue(search.q ?? "");
  }, [search.q, search.state, search.category]);

  const { temples, toggleBookmark, isLoading } = useTemples(filters);

  // Sort temples
  const sorted = [...temples].sort((a, b) => {
    if (filters.sortBy === "state") return a.state.localeCompare(b.state);
    return a.name.localeCompare(b.name);
  });

  const paginated = sorted.slice(0, page * PAGE_SIZE);
  const hasMore = paginated.length < sorted.length;

  // Debounced search → update URL + filters
  const handleSearchChange = useCallback(
    (val: string) => {
      setInputValue(val);
      if (debounceRef.current) clearTimeout(debounceRef.current);
      debounceRef.current = setTimeout(() => {
        setPage(1);
        setFilters((prev) => ({ ...prev, query: val }));
        navigate({
          search: {
            q: val,
            nearby: "",
            state: search.state ?? "",
            category: search.category ?? "",
          },
        });
      }, 320);
    },
    [navigate, search.state, search.category],
  );

  const handleFiltersChange = useCallback(
    (partial: Partial<SearchFilters>) => {
      setPage(1);
      setFilters((prev) => ({ ...prev, ...partial }));
      if (partial.state !== undefined || partial.category !== undefined) {
        navigate({
          search: {
            q: search.q ?? "",
            nearby: "",
            state:
              partial.state !== undefined
                ? (partial.state ?? "")
                : (search.state ?? ""),
            category:
              partial.category !== undefined
                ? (partial.category ?? "")
                : (search.category ?? ""),
          },
        });
      }
    },
    [navigate, search.q, search.state, search.category],
  );

  const handleClearAll = useCallback(() => {
    setPage(1);
    setInputValue("");
    setFilters({ query: "", sortBy: "name" });
    navigate({ search: { q: "", nearby: "", state: "", category: "" } });
  }, [navigate]);

  return (
    <div className="min-h-screen bg-background">
      {/* Hero search band */}
      <div className="bg-card border-b border-border shadow-warm-sm">
        <div className="container mx-auto px-4 py-8 max-w-5xl">
          <div className="text-center mb-6">
            <div className="flex items-center justify-center gap-2 mb-2">
              <Sparkles className="w-5 h-5 text-primary" />
              <span className="text-sm font-medium text-primary uppercase tracking-widest">
                Explore Sacred India
              </span>
            </div>
            <h1 className="font-display text-3xl sm:text-4xl font-bold text-foreground leading-tight">
              Discover Famous Temples of Bharat
            </h1>
            <p className="text-muted-foreground mt-2 text-sm sm:text-base">
              Search by name, deity, city, state, or tradition
            </p>
          </div>
          <SearchBar
            value={inputValue}
            onChange={handleSearchChange}
            placeholder="e.g. Kedarnath, Lord Shiva, Tamil Nadu, Jyotirlinga…"
          />
        </div>
      </div>

      <div className="container mx-auto px-4 py-6 max-w-7xl">
        <div className="flex gap-6 items-start">
          {/* Sidebar — desktop */}
          <aside className="hidden lg:block w-64 shrink-0 sticky top-6">
            <div className="bg-card border border-border rounded-xl p-5 shadow-warm-sm">
              <TempleFilters
                filters={filters}
                onFiltersChange={handleFiltersChange}
                onClearAll={handleClearAll}
                totalResults={sorted.length}
              />
            </div>
          </aside>

          {/* Main content */}
          <main className="flex-1 min-w-0">
            {/* Toolbar */}
            <div className="flex items-center justify-between mb-5 gap-3 flex-wrap">
              <div className="flex items-center gap-2">
                {/* Mobile filter sheet */}
                <Sheet>
                  <SheetTrigger asChild>
                    <Button
                      variant="outline"
                      size="sm"
                      className="lg:hidden h-10 gap-2 border-border"
                      data-ocid="mobile-filter-trigger"
                    >
                      <SlidersHorizontal className="w-4 h-4" />
                      Filters
                    </Button>
                  </SheetTrigger>
                  <SheetContent side="left" className="w-80 bg-card p-6">
                    <TempleFilters
                      filters={filters}
                      onFiltersChange={handleFiltersChange}
                      onClearAll={handleClearAll}
                      totalResults={sorted.length}
                    />
                  </SheetContent>
                </Sheet>

                <span className="text-sm text-muted-foreground hidden sm:block">
                  {sorted.length > 0 && (
                    <>
                      Showing{" "}
                      <span className="font-medium text-foreground">
                        {Math.min(paginated.length, sorted.length)}
                      </span>{" "}
                      of{" "}
                      <span className="font-medium text-foreground">
                        {sorted.length}
                      </span>{" "}
                      temples
                    </>
                  )}
                </span>
              </div>

              {/* View toggle */}
              <fieldset className="flex border border-border rounded-lg overflow-hidden bg-card">
                <legend className="sr-only">View mode</legend>
                <button
                  type="button"
                  onClick={() => setViewMode("grid")}
                  aria-label="Grid view"
                  aria-pressed={viewMode === "grid"}
                  data-ocid="view-grid"
                  className={`p-2.5 transition-colors ${
                    viewMode === "grid"
                      ? "bg-primary text-primary-foreground"
                      : "text-muted-foreground hover:text-foreground hover:bg-muted/50"
                  }`}
                >
                  <LayoutGrid className="w-4 h-4" />
                </button>
                <button
                  type="button"
                  onClick={() => setViewMode("list")}
                  aria-label="List view"
                  aria-pressed={viewMode === "list"}
                  data-ocid="view-list"
                  className={`p-2.5 transition-colors ${
                    viewMode === "list"
                      ? "bg-primary text-primary-foreground"
                      : "text-muted-foreground hover:text-foreground hover:bg-muted/50"
                  }`}
                >
                  <List className="w-4 h-4" />
                </button>
              </fieldset>
            </div>

            {/* Loading skeletons */}
            {isLoading && (
              <div
                className={
                  viewMode === "grid"
                    ? "grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5"
                    : "flex flex-col gap-4"
                }
              >
                {["s1", "s2", "s3", "s4", "s5", "s6"].map((sk) => (
                  <SkeletonCard key={sk} />
                ))}
              </div>
            )}

            {/* Results */}
            {!isLoading && sorted.length === 0 && (
              <EmptyState query={filters.query} />
            )}

            {!isLoading && sorted.length > 0 && (
              <>
                <AnimatePresence mode="wait">
                  <motion.div
                    key={`${filters.query}-${filters.state}-${filters.category}-${viewMode}`}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    transition={{ duration: 0.2 }}
                    className={
                      viewMode === "grid"
                        ? "grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5"
                        : "flex flex-col gap-4"
                    }
                    data-ocid="temple-results"
                  >
                    {paginated.map((temple, index) => (
                      <motion.div
                        key={temple.id}
                        initial={{ opacity: 0, y: 16 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: index * 0.05, duration: 0.3 }}
                      >
                        <TempleCard
                          temple={temple}
                          onBookmark={toggleBookmark}
                          variant={viewMode}
                        />
                      </motion.div>
                    ))}
                  </motion.div>
                </AnimatePresence>

                {/* Load more */}
                {hasMore && (
                  <div className="flex justify-center mt-10">
                    <Button
                      variant="outline"
                      size="lg"
                      onClick={() => setPage((p) => p + 1)}
                      className="h-12 px-8 text-sm font-medium border-primary/30 text-primary hover:bg-primary/10 transition-smooth"
                      data-ocid="load-more"
                    >
                      <Search className="w-4 h-4 mr-2" />
                      Load more temples
                    </Button>
                  </div>
                )}
              </>
            )}
          </main>
        </div>
      </div>
    </div>
  );
}
