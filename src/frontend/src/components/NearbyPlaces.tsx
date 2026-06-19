import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";
import {
  BedDouble,
  Landmark,
  MapPin,
  Mountain,
  ShoppingBag,
  Utensils,
  Waves,
} from "lucide-react";
import { useState } from "react";
import type { NearbyPlace, NearbyPlaceType } from "../types";

interface NearbyPlacesProps {
  places: NearbyPlace[];
}

const TYPE_CONFIG: Record<
  NearbyPlaceType,
  { label: string; icon: React.ReactNode; color: string }
> = {
  restaurant: {
    label: "Restaurant",
    icon: <Utensils className="w-4 h-4" />,
    color: "text-orange-600 dark:text-orange-400",
  },
  hotel: {
    label: "Hotel",
    icon: <BedDouble className="w-4 h-4" />,
    color: "text-blue-600 dark:text-blue-400",
  },
  museum: {
    label: "Museum",
    icon: <Landmark className="w-4 h-4" />,
    color: "text-purple-600 dark:text-purple-400",
  },
  waterpark: {
    label: "Water Park",
    icon: <Waves className="w-4 h-4" />,
    color: "text-cyan-600 dark:text-cyan-400",
  },
  shopping: {
    label: "Shopping",
    icon: <ShoppingBag className="w-4 h-4" />,
    color: "text-pink-600 dark:text-pink-400",
  },
  viewpoint: {
    label: "Viewpoint",
    icon: <Mountain className="w-4 h-4" />,
    color: "text-green-600 dark:text-green-400",
  },
};

const FILTER_OPTIONS: { id: NearbyPlaceType | "all"; label: string }[] = [
  { id: "all", label: "All" },
  { id: "restaurant", label: "Restaurants" },
  { id: "hotel", label: "Hotels" },
  { id: "museum", label: "Museums" },
  { id: "waterpark", label: "Water Parks" },
  { id: "shopping", label: "Shopping" },
  { id: "viewpoint", label: "Viewpoints" },
];

export default function NearbyPlaces({ places }: NearbyPlacesProps) {
  const [activeFilter, setActiveFilter] = useState<NearbyPlaceType | "all">(
    "all",
  );

  const filtered =
    activeFilter === "all"
      ? places
      : places.filter((p) => p.type === activeFilter);

  const availableFilters = FILTER_OPTIONS.filter(
    (f) => f.id === "all" || places.some((p) => p.type === f.id),
  );

  if (places.length === 0) {
    return (
      <div className="text-center py-12 text-muted-foreground">
        <MapPin className="w-10 h-10 mx-auto mb-3 opacity-40" />
        <p className="text-base font-medium">No nearby places listed yet</p>
        <p className="text-sm mt-1">
          Check local travel guides for recommendations
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-5">
      {/* Filter chips */}
      <fieldset
        className="flex flex-wrap gap-2"
        aria-label="Filter nearby places by type"
      >
        <legend className="sr-only">Filter by place type</legend>
        {availableFilters.map((f) => (
          <button
            key={f.id}
            type="button"
            onClick={() => setActiveFilter(f.id)}
            data-ocid={`nearby-filter-${f.id}`}
            className={cn(
              "px-4 py-2 rounded-full text-sm font-medium border transition-smooth focus-ring min-h-[40px]",
              activeFilter === f.id
                ? "bg-primary text-primary-foreground border-primary"
                : "bg-card border-border text-muted-foreground hover:text-foreground hover:border-primary/40",
            )}
          >
            {f.label}
          </button>
        ))}
      </fieldset>

      {/* Places grid */}
      {filtered.length === 0 ? (
        <div className="text-center py-8 text-muted-foreground">
          <p>No {activeFilter} listed nearby.</p>
        </div>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2">
          {filtered.map((place) => {
            const config = TYPE_CONFIG[place.type];
            return (
              <Card
                key={place.id}
                data-ocid={`nearby-place-${place.id}`}
                className="border-border shadow-warm-sm hover:shadow-warm-md transition-smooth"
              >
                <CardContent className="p-4 flex gap-3">
                  <div
                    className={cn(
                      "w-10 h-10 rounded-lg bg-muted flex items-center justify-center shrink-0",
                      config.color,
                    )}
                  >
                    {config.icon}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2">
                      <p className="font-semibold text-foreground text-sm leading-tight truncate">
                        {place.name}
                      </p>
                      <Badge variant="secondary" className="text-xs shrink-0">
                        {place.distance}
                      </Badge>
                    </div>
                    <p className="text-xs text-muted-foreground mt-0.5 flex items-center gap-1">
                      <span className={config.color}>{config.icon}</span>
                      {config.label}
                    </p>
                    {place.description && (
                      <p className="text-xs text-muted-foreground mt-1.5 line-clamp-2">
                        {place.description}
                      </p>
                    )}
                    {place.address && (
                      <p className="text-xs text-muted-foreground mt-1 flex items-center gap-1 truncate">
                        <MapPin className="w-3 h-3 shrink-0" />
                        {place.address}
                      </p>
                    )}
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
