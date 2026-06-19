import { useMemo } from "react";
import type { SearchFilters } from "../types";
import {
  type MappedTempleCard,
  mapTempleToCard,
  useAllTemples,
} from "./useQueries";
import { useUserProfile } from "./useUserProfile";

export type { MappedTempleCard };

// All 36 Indian states and union territories with temple counts
export const INDIA_STATES_WITH_COUNTS: Array<{ name: string; count: number }> =
  [
    { name: "Andhra Pradesh", count: 5 },
    { name: "Arunachal Pradesh", count: 5 },
    { name: "Assam", count: 5 },
    { name: "Bihar", count: 5 },
    { name: "Chhattisgarh", count: 5 },
    { name: "Goa", count: 5 },
    { name: "Gujarat", count: 6 },
    { name: "Haryana", count: 5 },
    { name: "Himachal Pradesh", count: 5 },
    { name: "Jharkhand", count: 5 },
    { name: "Karnataka", count: 6 },
    { name: "Kerala", count: 5 },
    { name: "Madhya Pradesh", count: 6 },
    { name: "Maharashtra", count: 6 },
    { name: "Manipur", count: 5 },
    { name: "Meghalaya", count: 5 },
    { name: "Mizoram", count: 5 },
    { name: "Nagaland", count: 5 },
    { name: "Odisha", count: 5 },
    { name: "Punjab", count: 5 },
    { name: "Rajasthan", count: 6 },
    { name: "Sikkim", count: 5 },
    { name: "Tamil Nadu", count: 7 },
    { name: "Telangana", count: 5 },
    { name: "Tripura", count: 5 },
    { name: "Uttar Pradesh", count: 7 },
    { name: "Uttarakhand", count: 6 },
    { name: "West Bengal", count: 5 },
    { name: "Andaman & Nicobar Islands", count: 5 },
    { name: "Chandigarh", count: 5 },
    { name: "Dadra & Nagar Haveli", count: 5 },
    { name: "Daman & Diu", count: 5 },
    { name: "Delhi", count: 6 },
    { name: "Jammu & Kashmir", count: 5 },
    { name: "Ladakh", count: 5 },
    { name: "Lakshadweep", count: 5 },
    { name: "Puducherry", count: 5 },
  ];

const INDIA_STATES = INDIA_STATES_WITH_COUNTS.map((s) => s.name);

export function useTempleOfTheDay() {
  const { data: allTemples = [] } = useAllTemples();
  return useMemo(() => {
    if (allTemples.length === 0) return null;
    const dayIndex = Math.floor(Date.now() / 86400000) % allTemples.length;
    return mapTempleToCard(allTemples[dayIndex]);
  }, [allTemples]);
}

export function useTemples(filters?: SearchFilters) {
  const { profile, saveProfile } = useUserProfile();

  const bookmarkSet = useMemo(
    () => new Set<string>(profile?.bookmarks ?? []),
    [profile?.bookmarks],
  );

  const { data: allTemples = [], isLoading } = useAllTemples();

  const temples = useMemo<MappedTempleCard[]>(() => {
    let results = allTemples.map((t) => mapTempleToCard(t, bookmarkSet));

    if (filters?.query) {
      const q = filters.query.toLowerCase();
      results = results.filter(
        (t) =>
          t.name.toLowerCase().includes(q) ||
          t.deity.toLowerCase().includes(q) ||
          t.city.toLowerCase().includes(q) ||
          t.state.toLowerCase().includes(q) ||
          t.category.toLowerCase().includes(q),
      );
    }

    if (filters?.state) {
      results = results.filter(
        (t) => t.state.toLowerCase() === filters.state!.toLowerCase(),
      );
    }

    if (filters?.category) {
      results = results.filter((t) =>
        t.category.toLowerCase().includes(filters.category!.toLowerCase()),
      );
    }

    return results;
  }, [allTemples, filters, bookmarkSet]);

  const toggleBookmark = (id: string) => {
    const current = profile?.bookmarks ?? [];
    const next = current.includes(id)
      ? current.filter((b) => b !== id)
      : [...current, id];
    saveProfile({ bookmarks: next });
  };

  return {
    temples,
    allTemples: allTemples.map((t) => mapTempleToCard(t, bookmarkSet)),
    states: INDIA_STATES,
    toggleBookmark,
    isLoading,
  };
}

export function useFeaturedTemples() {
  const { profile, saveProfile } = useUserProfile();
  const bookmarkSet = useMemo(
    () => new Set<string>(profile?.bookmarks ?? []),
    [profile?.bookmarks],
  );
  const { data: allTemples = [], isLoading } = useAllTemples();

  const temples = useMemo(
    () => allTemples.slice(0, 6).map((t) => mapTempleToCard(t, bookmarkSet)),
    [allTemples, bookmarkSet],
  );

  const toggleBookmark = (id: string) => {
    const current = profile?.bookmarks ?? [];
    const next = current.includes(id)
      ? current.filter((b) => b !== id)
      : [...current, id];
    saveProfile({ bookmarks: next });
  };

  return { temples, isLoading, toggleBookmark };
}
