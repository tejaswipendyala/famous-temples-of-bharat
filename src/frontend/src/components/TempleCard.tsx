import { Button } from "@/components/ui/button";
import { Link } from "@tanstack/react-router";
import {
  AlertTriangle,
  ArrowRight,
  Bookmark,
  BookmarkCheck,
  Building2,
  Clock,
  ExternalLink,
  Heart,
  Image,
  MapPin,
} from "lucide-react";
import { useState } from "react";

export interface TempleCardData {
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
  architectureStyle?: string;
  averageVisitDuration?: string;
  nonHinduRestriction?: boolean;
  tags?: string[];
}

/** Deterministic hue from temple name for unique gradient per temple */
function nameToHue(name: string): number {
  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = (hash * 31 + name.charCodeAt(i)) & 0xffffffff;
  }
  return Math.abs(hash) % 360;
}

/** Warm saffron/orange gradient banner replacing the old image area */
function TempleBanner({ name, deity }: { name: string; deity: string }) {
  const hue = nameToHue(name);
  // Keep in warm orange/saffron range: base hue 30–55 blended with name hue
  const h1 = 30 + (hue % 25);
  const h2 = 55 + (hue % 20);
  return (
    <div
      className="w-full h-full flex flex-col items-center justify-center gap-2 select-none"
      style={{
        background: `linear-gradient(135deg, oklch(0.55 0.18 ${h1}), oklch(0.42 0.22 ${h2}))`,
      }}
      aria-hidden="true"
    >
      <span className="text-4xl" role="img" aria-label="temple">
        🛕
      </span>
      <span
        className="text-xs font-medium text-center px-3 leading-tight line-clamp-2"
        style={{ color: "oklch(0.97 0.04 90)" }}
      >
        {deity}
      </span>
    </div>
  );
}

/** Google Images search link for a temple */
function googleImagesUrl(name: string): string {
  return `https://www.google.com/search?q=${encodeURIComponent(`${name} temple india`)}&tbm=isch`;
}

/** Google Maps search link for a temple */
function googleMapsUrl(name: string, city: string, state: string): string {
  return `https://www.google.com/maps/search/${encodeURIComponent(`${name} ${city} ${state} india`)}`;
}

const CATEGORY_COLORS: Record<string, string> = {
  "UNESCO Heritage": "bg-primary/10 text-primary border-primary/20",
  Jyotirlinga: "bg-accent/10 text-accent border-accent/20",
  "Shakti Peetha": "bg-accent/10 text-accent border-accent/20",
  "Char Dham": "bg-primary/15 text-primary border-primary/30",
  "Pancha Bhuta Stalagam":
    "bg-secondary text-secondary-foreground border-border",
  "Divya Desam": "bg-primary/10 text-primary border-primary/20",
  Heritage: "bg-muted text-muted-foreground border-border",
};

interface TempleCardProps {
  temple: TempleCardData;
  onBookmark?: (id: string) => void;
  variant?: "grid" | "list";
  showDonate?: boolean;
}

export default function TempleCard({
  temple,
  onBookmark,
  variant = "grid",
  showDonate = true,
}: TempleCardProps) {
  const [bookmarked, setBookmarked] = useState(temple.isBookmarked ?? false);
  const firstTiming = temple.darshanaTimings[0];
  const categoryClass =
    CATEGORY_COLORS[temple.category] ??
    "bg-muted text-muted-foreground border-border";

  const handleBookmark = () => {
    setBookmarked((b) => !b);
    onBookmark?.(temple.id);
  };

  const imagesHref = googleImagesUrl(temple.name);
  const mapsHref = googleMapsUrl(temple.name, temple.city, temple.state);

  if (variant === "list") {
    return (
      <div
        className="bg-card border border-border rounded-lg overflow-hidden flex gap-0 hover:shadow-warm-md transition-smooth group"
        data-ocid={`temple-card-${temple.id}`}
      >
        {/* Compact banner instead of image */}
        <div className="w-28 sm:w-36 shrink-0 overflow-hidden">
          <TempleBanner name={temple.name} deity={temple.deity} />
        </div>

        <div className="flex flex-col p-4 gap-2 flex-1 min-w-0">
          <div className="flex items-start justify-between gap-2">
            <h3 className="font-display font-semibold text-base text-foreground leading-snug line-clamp-2">
              {temple.name}
            </h3>
            {onBookmark && (
              <button
                onClick={handleBookmark}
                aria-label={bookmarked ? "Remove bookmark" : "Add bookmark"}
                className="shrink-0 p-1 rounded text-muted-foreground hover:text-primary transition-colors focus-visible:ring-2 focus-visible:ring-primary"
                type="button"
                data-ocid={`bookmark-${temple.id}`}
              >
                {bookmarked ? (
                  <BookmarkCheck className="w-5 h-5 text-primary" />
                ) : (
                  <Bookmark className="w-5 h-5" />
                )}
              </button>
            )}
          </div>

          <div className="flex items-center gap-1 text-xs text-muted-foreground">
            <MapPin className="w-3.5 h-3.5 shrink-0" />
            <span className="truncate">
              {temple.city}, {temple.state}
            </span>
          </div>

          {firstTiming && (
            <div className="flex items-center gap-1 text-xs text-muted-foreground">
              <Clock className="w-3.5 h-3.5 shrink-0" />
              <span>
                {firstTiming.label}: {firstTiming.openTime} –{" "}
                {firstTiming.closeTime}
              </span>
            </div>
          )}

          <div className="flex items-center justify-between mt-auto pt-1 gap-2 flex-wrap">
            <span
              className={`inline-flex items-center text-xs font-medium px-2 py-0.5 rounded-full border ${categoryClass}`}
            >
              {temple.category}
            </span>
            <div className="flex items-center gap-1 flex-wrap">
              <a
                href={mapsHref}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1 text-xs font-medium px-2 py-1 rounded border border-blue-500/30 text-blue-600 hover:bg-blue-50/10 transition-colors"
                data-ocid={`maps-link-${temple.id}`}
              >
                <MapPin className="w-3 h-3" /> Maps
              </a>
              <a
                href={imagesHref}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1 text-xs font-medium px-2 py-1 rounded border border-amber-500/30 text-amber-600 hover:bg-amber-50/10 transition-colors"
                data-ocid={`photos-link-${temple.id}`}
              >
                <Image className="w-3 h-3" /> Photos
              </a>
              {showDonate && (
                <Button
                  asChild
                  size="sm"
                  variant="ghost"
                  className="text-xs h-8 px-2 text-primary hover:bg-primary/10 gap-1"
                  data-ocid={`donate-${temple.id}`}
                >
                  <Link
                    to="/temples/$id"
                    params={{ id: temple.id }}
                    hash="donate"
                  >
                    <Heart className="w-3 h-3" /> Donate
                  </Link>
                </Button>
              )}
              <Button
                asChild
                size="sm"
                variant="ghost"
                className="text-xs h-8 px-3 text-primary hover:bg-primary/10"
                data-ocid={`view-${temple.id}`}
              >
                <Link to="/temples/$id" params={{ id: temple.id }}>
                  View <ArrowRight className="w-3 h-3 ml-1" />
                </Link>
              </Button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // ─── Grid variant ────────────────────────────────────────────────────────
  return (
    <div
      className="bg-card border border-border rounded-xl overflow-hidden hover:shadow-warm-lg transition-smooth group flex flex-col"
      data-ocid={`temple-card-${temple.id}`}
    >
      {/* Banner replaces image */}
      <div className="relative aspect-[4/3] overflow-hidden">
        <TempleBanner name={temple.name} deity={temple.deity} />

        {onBookmark && (
          <button
            onClick={handleBookmark}
            aria-label={bookmarked ? "Remove bookmark" : "Add bookmark"}
            className="absolute top-3 right-3 w-9 h-9 flex items-center justify-center rounded-full bg-card/80 backdrop-blur-sm text-foreground hover:bg-card transition-colors shadow-warm-sm focus-visible:ring-2 focus-visible:ring-primary"
            type="button"
            data-ocid={`bookmark-${temple.id}`}
          >
            {bookmarked ? (
              <BookmarkCheck className="w-5 h-5 text-primary" />
            ) : (
              <Bookmark className="w-5 h-5" />
            )}
          </button>
        )}

        <div className="absolute bottom-3 left-3">
          <span
            className={`inline-flex items-center text-xs font-medium px-2.5 py-1 rounded-full border backdrop-blur-sm ${categoryClass}`}
          >
            {temple.category}
          </span>
        </div>

        {temple.nonHinduRestriction && (
          <div className="absolute top-3 left-3">
            <span className="inline-flex items-center gap-1 text-xs font-medium px-2 py-0.5 rounded-full bg-destructive/90 text-destructive-foreground">
              <AlertTriangle className="w-3 h-3" /> Hindus Only
            </span>
          </div>
        )}
      </div>

      {/* Content */}
      <div className="flex flex-col gap-2 p-4 flex-1">
        <h3 className="font-display font-semibold text-base text-foreground leading-snug line-clamp-2">
          {temple.name}
        </h3>
        <p className="text-xs text-accent font-medium">{temple.deity}</p>

        <div className="flex items-center gap-1 text-sm text-muted-foreground">
          <MapPin className="w-4 h-4 shrink-0" />
          <span className="truncate">
            {temple.city}, {temple.state}
          </span>
        </div>

        {firstTiming && (
          <div className="flex items-center gap-1 text-xs text-muted-foreground">
            <Clock className="w-3.5 h-3.5 shrink-0" />
            <span>
              {firstTiming.label}: {firstTiming.openTime} –{" "}
              {firstTiming.closeTime}
            </span>
          </div>
        )}

        {/* Architecture & Duration */}
        <div className="flex flex-wrap gap-2 mt-1">
          {temple.architectureStyle && (
            <span className="inline-flex items-center gap-1 text-xs text-muted-foreground bg-muted/40 px-2 py-0.5 rounded">
              <Building2 className="w-3 h-3" />
              {temple.architectureStyle}
            </span>
          )}
          {temple.averageVisitDuration && (
            <span className="inline-flex items-center gap-1 text-xs text-muted-foreground bg-muted/40 px-2 py-0.5 rounded">
              <Clock className="w-3 h-3" />
              {temple.averageVisitDuration}
            </span>
          )}
        </div>

        {/* Tags chips */}
        {temple.tags && temple.tags.length > 0 && (
          <div className="flex flex-wrap gap-1 mt-0.5">
            {temple.tags.slice(0, 3).map((tag) => (
              <span
                key={tag}
                className="text-xs px-2 py-0.5 rounded-full bg-primary/8 text-primary border border-primary/15"
              >
                {tag}
              </span>
            ))}
          </div>
        )}

        {/* Google Links */}
        <div className="flex gap-2 mt-2">
          <a
            href={imagesHref}
            target="_blank"
            rel="noopener noreferrer"
            className="flex-1 inline-flex items-center justify-center gap-1.5 text-xs font-medium h-8 px-2 rounded border border-amber-500/40 text-amber-600 hover:bg-amber-500/10 transition-colors"
            data-ocid={`photos-link-${temple.id}`}
          >
            <Image className="w-3.5 h-3.5" /> View Photos
          </a>
          <a
            href={mapsHref}
            target="_blank"
            rel="noopener noreferrer"
            className="flex-1 inline-flex items-center justify-center gap-1.5 text-xs font-medium h-8 px-2 rounded border border-blue-500/40 text-blue-600 hover:bg-blue-500/10 transition-colors"
            data-ocid={`maps-link-${temple.id}`}
          >
            <MapPin className="w-3.5 h-3.5" /> View on Maps
          </a>
        </div>

        {/* Action buttons */}
        <div className="flex gap-2 mt-1">
          <Button
            asChild
            variant="outline"
            size="sm"
            className="flex-1 h-9 text-sm font-medium border-primary/30 text-primary hover:bg-primary/10"
            data-ocid={`view-details-${temple.id}`}
          >
            <Link to="/temples/$id" params={{ id: temple.id }}>
              View Details <ExternalLink className="w-3 h-3 ml-1" />
            </Link>
          </Button>
          {showDonate ? (
            <Button
              asChild
              size="sm"
              className="flex-1 h-9 text-sm font-medium bg-primary text-primary-foreground hover:bg-primary/90 gap-1"
              data-ocid={`donate-btn-${temple.id}`}
            >
              <Link to="/temples/$id" params={{ id: temple.id }} hash="donate">
                <Heart className="w-3.5 h-3.5" /> Donate
              </Link>
            </Button>
          ) : (
            <Button
              asChild
              size="sm"
              className="flex-1 h-9 text-sm font-medium bg-primary text-primary-foreground hover:bg-primary/90"
              data-ocid={`plan-visit-${temple.id}`}
            >
              <Link to="/temples/$id" params={{ id: temple.id }}>
                Plan Visit
              </Link>
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}
