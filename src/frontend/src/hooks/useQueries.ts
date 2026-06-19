import { useActor } from "@caffeineai/core-infrastructure";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { createActor } from "../backend";
import type {
  CreateDonationInput,
  DonationCheckoutResult,
  Temple,
  backendInterface,
} from "../backend.d";

// ─── Map backend Temple to frontend TempleCard shape ────────────────────────
export interface MappedTempleCard {
  id: string;
  name: string;
  deity: string;
  city: string;
  state: string;
  darshanaTimings: Array<{
    label: string;
    openTime: string;
    closeTime: string;
  }>;
  category: string;
  isBookmarked?: boolean;
  description?: string;
  history?: string;
  address?: string;
  donationOptions?: Temple["donationOptions"];
  architectureStyle?: string;
  averageVisitDuration?: string;
  nonHinduRestriction?: boolean;
  tags?: string[];
  contactInfo?: {
    phone?: string;
    email?: string;
    website?: string;
  };
}

export function mapTempleToCard(
  temple: Temple,
  bookmarkSet?: Set<string>,
): MappedTempleCard {
  const idStr = temple.id.toString();
  return {
    id: idStr,
    name: temple.name,
    deity: temple.deity,
    city: temple.city,
    state: temple.state,
    darshanaTimings: temple.darshanTimings.map((dt) => ({
      label: dt.timingLabel,
      openTime: dt.openTime,
      closeTime: dt.closeTime,
    })),
    category: temple.architectureStyle || temple.tags[0] || "Heritage",
    isBookmarked: bookmarkSet ? bookmarkSet.has(idStr) : false,
    description: temple.description,
    history: temple.history,
    address: temple.address,
    donationOptions: temple.donationOptions,
    architectureStyle: temple.architectureStyle,
    averageVisitDuration: temple.averageVisitDuration
      ? `${Number(temple.averageVisitDuration)} hours`
      : undefined,
    nonHinduRestriction: temple.nonHinduRestriction,
    tags: temple.tags,
    contactInfo: temple.contactInfo,
  };
}

// ─── Hooks ───────────────────────────────────────────────────────────────────

export function useAllTemples() {
  const { actor: rawActor, isFetching } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  return useQuery<Temple[]>({
    queryKey: ["temples", "all"],
    queryFn: async () => {
      if (!actor) throw new Error("Actor not ready");
      return actor.getAllTemples();
    },
    enabled: !!actor && !isFetching,
    staleTime: 5 * 60 * 1000,
    retry: 3,
  });
}

export function useTemple(id: string | undefined) {
  const { actor: rawActor, isFetching } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  return useQuery<Temple | null>({
    queryKey: ["temple", id],
    queryFn: async () => {
      if (!actor) throw new Error("Actor not ready");
      if (!id) throw new Error("Temple ID required");
      return actor.getTemple(BigInt(id));
    },
    enabled: !!actor && !isFetching && !!id,
    staleTime: 5 * 60 * 1000,
    retry: 3,
  });
}

export interface SearchFiltersBackend {
  query: string;
  state?: string;
  city?: string;
  offset?: number;
  limit?: number;
}

export function useSearchTemples(filters: SearchFiltersBackend) {
  const { actor: rawActor, isFetching } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  return useQuery({
    queryKey: ["temples", "search", filters],
    queryFn: async () => {
      if (!actor) throw new Error("Actor not ready");
      return actor.searchTemples({
        searchTerm: filters.query,
        stateFilter: filters.state || undefined,
        cityFilter: filters.city || undefined,
        pagination: {
          offset: BigInt(filters.offset ?? 0),
          limit: BigInt(filters.limit ?? 200),
        },
      });
    },
    enabled: !!actor && !isFetching,
    staleTime: 2 * 60 * 1000,
    retry: 3,
  });
}

export function useCreateCheckoutSession() {
  const { actor: rawActor } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  const queryClient = useQueryClient();
  return useMutation<DonationCheckoutResult, Error, CreateDonationInput>({
    mutationFn: async (input: CreateDonationInput) => {
      if (!actor) throw new Error("Not connected to backend");
      return actor.createCheckoutSession(input);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["donations"] });
    },
  });
}
