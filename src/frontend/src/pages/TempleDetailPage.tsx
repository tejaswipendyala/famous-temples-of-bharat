import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { Textarea } from "@/components/ui/textarea";
import { Link, useParams } from "@tanstack/react-router";
import {
  AlertTriangle,
  ArrowLeft,
  Bookmark,
  BookmarkCheck,
  Building2,
  Calendar,
  Clock,
  Coins,
  ExternalLink,
  Globe,
  Heart,
  HelpCircle,
  Home,
  Image,
  Info,
  MapPin,
  MessageSquare,
  Phone,
  Share2,
  Star,
  Tag,
  Users,
} from "lucide-react";
import { motion } from "motion/react";
import { useState } from "react";
import { toast } from "sonner";

import DonationSection from "../components/DonationSection";
import MapSection from "../components/MapSection";
import NearbyPlaces from "../components/NearbyPlaces";
import StarRating from "../components/StarRating";
import TabNav, { type TabItem } from "../components/TabNav";
import { useAuth } from "../hooks/useAuth";
import { useTemple } from "../hooks/useQueries";
import type { NearbyPlace, Review } from "../types";

// ─── Helpers ────────────────────────────────────────────────────────────────

function googleImagesUrl(name: string): string {
  return `https://www.google.com/search?q=${encodeURIComponent(`${name} temple india`)}&tbm=isch`;
}

function googleMapsUrl(name: string, city: string, state: string): string {
  return `https://www.google.com/maps/search/${encodeURIComponent(`${name} ${city} ${state} india`)}`;
}

// ─── Tab configuration ──────────────────────────────────────────────────────

const TABS: TabItem[] = [
  { id: "overview", label: "Overview", icon: <Info className="w-4 h-4" /> },
  {
    id: "timings",
    label: "Timings & Poojas",
    icon: <Clock className="w-4 h-4" />,
  },
  {
    id: "festivals",
    label: "Festivals",
    icon: <Calendar className="w-4 h-4" />,
  },
  { id: "donations", label: "Donations", icon: <Coins className="w-4 h-4" /> },
  { id: "nearby", label: "Nearby", icon: <MapPin className="w-4 h-4" /> },
  { id: "faqs", label: "FAQs", icon: <HelpCircle className="w-4 h-4" /> },
  {
    id: "reviews",
    label: "Reviews",
    icon: <MessageSquare className="w-4 h-4" />,
  },
];

// ─── Sub-components ────────────────────────────────────────────────────────

function InfoRow({
  icon,
  label,
  value,
}: { icon: React.ReactNode; label: string; value: string }) {
  return (
    <div className="flex items-start gap-3 py-2.5 border-b border-border last:border-0">
      <div className="text-primary shrink-0 mt-0.5">{icon}</div>
      <div className="flex-1 min-w-0">
        <p className="text-xs text-muted-foreground uppercase tracking-wide">
          {label}
        </p>
        <p className="text-sm font-medium text-foreground mt-0.5 break-words">
          {value}
        </p>
      </div>
    </div>
  );
}

function ReviewCard({ review }: { review: Review }) {
  const date = new Date(review.createdAt).toLocaleDateString("en-IN", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
  return (
    <Card
      className="border-border shadow-warm-sm"
      data-ocid={`review-card-${review.id}`}
    >
      <CardContent className="p-4">
        <div className="flex items-start justify-between gap-3">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold text-sm shrink-0">
              {review.userName.charAt(0)}
            </div>
            <div>
              <p className="font-semibold text-sm text-foreground">
                {review.userName}
              </p>
              <p className="text-xs text-muted-foreground">{date}</p>
            </div>
          </div>
          <StarRating value={review.rating} size="sm" />
        </div>
        <p className="text-sm text-muted-foreground mt-3 leading-relaxed">
          {review.comment}
        </p>
      </CardContent>
    </Card>
  );
}

// ─── Loading skeleton ───────────────────────────────────────────────────────

function TempleDetailSkeleton() {
  return (
    <div className="animate-pulse">
      <Skeleton className="w-full h-48 rounded-none" />
      <div className="container mx-auto px-4 py-6 max-w-5xl space-y-4">
        <Skeleton className="h-10 w-2/3" />
        <Skeleton className="h-5 w-1/3" />
        <div className="flex gap-2 mt-4">
          {[1, 2, 3, 4, 5, 6, 7].map((i) => (
            <Skeleton key={i} className="h-12 w-24 rounded" />
          ))}
        </div>
        <div className="space-y-3 mt-6">
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-3/4" />
        </div>
      </div>
    </div>
  );
}

// ─── Main page ──────────────────────────────────────────────────────────────

export default function TempleDetailPage() {
  const { id } = useParams({ from: "/temples/$id" });
  const { isAuthenticated } = useAuth();

  const [activeTab, setActiveTab] = useState("overview");
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [localReviews, setLocalReviews] = useState<Review[]>([]);
  const [newRating, setNewRating] = useState(0);
  const [newComment, setNewComment] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const { data: backendTemple, isLoading } = useTemple(id);
  if (isLoading) return <TempleDetailSkeleton />;

  if (!backendTemple) {
    return (
      <div
        className="container mx-auto px-4 py-20 max-w-xl text-center"
        data-ocid="temple-not-found"
      >
        <div className="text-6xl mb-4">🛕</div>
        <h1 className="font-display text-2xl font-bold text-foreground mb-2">
          Temple Not Found
        </h1>
        <p className="text-muted-foreground mb-6">
          We couldn't find a temple with this ID. It may have been moved or the
          link might be incorrect.
        </p>
        <Link
          to="/temples"
          search={{ q: "", nearby: "", state: "", category: "" }}
        >
          <Button className="btn-accessible gap-2">
            <ArrowLeft className="w-4 h-4" />
            Browse All Temples
          </Button>
        </Link>
      </div>
    );
  }

  // ─── Map backend Temple to display shape ─────────────────────────────────
  const templeId = backendTemple.id.toString();
  const category =
    backendTemple.architectureStyle || backendTemple.tags[0] || "Heritage";

  const darshanaTimings = backendTemple.darshanTimings.map((dt) => ({
    label: dt.timingLabel,
    openTime: dt.openTime,
    closeTime: dt.closeTime,
  }));

  const poojas = backendTemple.poojaSchedule.map((p) => ({
    name: p.name,
    time: p.time,
    description: p.description,
    cost: p.price ? `₹${Number(p.price).toLocaleString("en-IN")}` : "Free",
  }));

  const festivals = backendTemple.festivalCalendar.map((f) => ({
    name: f.name,
    date: f.date,
    description: f.significance,
  }));

  const allReviews: Review[] = [...localReviews];
  const avgRating =
    allReviews.length > 0
      ? allReviews.reduce((sum, r) => sum + r.rating, 0) / allReviews.length
      : 0;

  const visitDuration = backendTemple.averageVisitDuration
    ? `${Number(backendTemple.averageVisitDuration)} hours`
    : "1.5–3 hours";

  const nearbyPlaces: NearbyPlace[] = [];

  // ─── Derived hue for hero gradient ───────────────────────────────────────
  const nameHue =
    Math.abs(
      Array.from(backendTemple.name).reduce(
        (h, c) => (h * 31 + c.charCodeAt(0)) & 0xffffffff,
        0,
      ),
    ) % 360;
  const heroH1 = 28 + (nameHue % 22);
  const heroH2 = 52 + (nameHue % 18);

  const imagesHref = googleImagesUrl(backendTemple.name);
  const mapsHref = googleMapsUrl(
    backendTemple.name,
    backendTemple.city,
    backendTemple.state,
  );

  const handleBookmark = () => {
    setIsBookmarked((b) => !b);
    toast.success(
      isBookmarked
        ? "Removed from saved temples"
        : "Temple saved to your bookmarks",
    );
  };

  const handleShare = async () => {
    const url = window.location.href;
    if (navigator.share) {
      await navigator.share({ title: backendTemple.name, url });
    } else {
      await navigator.clipboard.writeText(url);
      toast.success("Link copied to clipboard");
    }
  };

  const handleSubmitReview = (e: React.FormEvent) => {
    e.preventDefault();
    if (!isAuthenticated) {
      toast.error("Please log in to submit a review");
      return;
    }
    if (newRating === 0) {
      toast.error("Please select a star rating");
      return;
    }
    if (newComment.trim().length < 10) {
      toast.error("Please write at least 10 characters");
      return;
    }
    setSubmitting(true);
    setTimeout(() => {
      const review: Review = {
        id: `local-${Date.now()}`,
        userId: "current-user",
        userName: "You",
        rating: newRating,
        comment: newComment,
        createdAt: new Date().toISOString(),
      };
      setLocalReviews((r) => [review, ...r]);
      setNewRating(0);
      setNewComment("");
      setSubmitting(false);
      toast.success("Review submitted! Thank you.");
    }, 800);
  };

  // ─── Tab content ──────────────────────────────────────────────────────────

  const renderTab = () => {
    switch (activeTab) {
      case "overview":
        return (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-6"
          >
            {/* Google links — prominent CTA row */}
            <div className="flex flex-col sm:flex-row gap-3 p-4 rounded-xl bg-card border border-border shadow-warm-sm">
              <a
                href={imagesHref}
                target="_blank"
                rel="noopener noreferrer"
                className="flex-1 inline-flex items-center justify-center gap-2 h-11 px-4 rounded-lg border-2 border-amber-500/50 bg-amber-500/8 text-amber-700 hover:bg-amber-500/15 font-medium text-sm transition-colors"
                data-ocid={`detail-photos-link-${templeId}`}
              >
                <Image className="w-4 h-4" />
                View Temple Photos on Google
                <ExternalLink className="w-3.5 h-3.5 opacity-60" />
              </a>
              <a
                href={mapsHref}
                target="_blank"
                rel="noopener noreferrer"
                className="flex-1 inline-flex items-center justify-center gap-2 h-11 px-4 rounded-lg border-2 border-blue-500/50 bg-blue-500/8 text-blue-700 hover:bg-blue-500/15 font-medium text-sm transition-colors"
                data-ocid={`detail-maps-link-${templeId}`}
              >
                <MapPin className="w-4 h-4" />
                View on Google Maps
                <ExternalLink className="w-3.5 h-3.5 opacity-60" />
              </a>
            </div>

            {/* History */}
            <Card className="border-border shadow-warm-sm">
              <CardHeader className="pb-2">
                <CardTitle className="font-display text-lg flex items-center gap-2">
                  <Info className="w-5 h-5 text-primary" /> History &
                  Significance
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-foreground leading-relaxed whitespace-pre-line">
                  {backendTemple.history || backendTemple.description}
                </p>
              </CardContent>
            </Card>

            {/* Basic info */}
            <Card className="border-border shadow-warm-sm">
              <CardHeader className="pb-2">
                <CardTitle className="font-display text-lg flex items-center gap-2">
                  <Home className="w-5 h-5 text-primary" /> Temple Information
                </CardTitle>
              </CardHeader>
              <CardContent className="divide-y-0">
                <InfoRow
                  icon={<MapPin className="w-4 h-4" />}
                  label="State"
                  value={backendTemple.state}
                />
                <InfoRow
                  icon={<MapPin className="w-4 h-4" />}
                  label="City"
                  value={backendTemple.city}
                />
                <InfoRow
                  icon={<Home className="w-4 h-4" />}
                  label="Address"
                  value={backendTemple.address}
                />
                <InfoRow
                  icon={<Heart className="w-4 h-4" />}
                  label="Main Deity"
                  value={backendTemple.deity}
                />
                <InfoRow
                  icon={<Building2 className="w-4 h-4" />}
                  label="Architecture Style"
                  value={backendTemple.architectureStyle || category}
                />
                {backendTemple.district && (
                  <InfoRow
                    icon={<MapPin className="w-4 h-4" />}
                    label="District"
                    value={backendTemple.district}
                  />
                )}
                <InfoRow
                  icon={<Clock className="w-4 h-4" />}
                  label="Suggested Visit Duration"
                  value={visitDuration}
                />
                {backendTemple.nonHinduRestriction && (
                  <InfoRow
                    icon={<AlertTriangle className="w-4 h-4" />}
                    label="Entry Restrictions"
                    value="Inner sanctum restricted to Hindus only"
                  />
                )}
              </CardContent>
            </Card>

            {/* Additional Features */}
            <Card className="border-border shadow-warm-sm">
              <CardHeader className="pb-2">
                <CardTitle className="font-display text-lg flex items-center gap-2">
                  <Star className="w-5 h-5 text-primary" /> Temple Features
                </CardTitle>
              </CardHeader>
              <CardContent>
                {/* Stats grid */}
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-4">
                  <div className="bg-muted/40 rounded-lg p-3 text-center">
                    <p className="font-display text-2xl font-bold text-primary">
                      {darshanaTimings.length}
                    </p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      Darshan Sessions
                    </p>
                  </div>
                  <div className="bg-muted/40 rounded-lg p-3 text-center">
                    <p className="font-display text-2xl font-bold text-primary">
                      {poojas.length}
                    </p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      Daily Poojas
                    </p>
                  </div>
                  <div className="bg-muted/40 rounded-lg p-3 text-center">
                    <p className="font-display text-2xl font-bold text-primary">
                      {festivals.length}
                    </p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      Annual Festivals
                    </p>
                  </div>
                  <div className="bg-muted/40 rounded-lg p-3 text-center">
                    <p className="font-display text-2xl font-bold text-primary">
                      {backendTemple.donationOptions.length}
                    </p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      Donation Options
                    </p>
                  </div>
                </div>

                {/* Tags */}
                {backendTemple.tags.length > 0 && (
                  <div className="mb-4">
                    <p className="text-xs text-muted-foreground uppercase tracking-wide mb-2 flex items-center gap-1">
                      <Tag className="w-3.5 h-3.5" /> Highlights
                    </p>
                    <div className="flex flex-wrap gap-1.5">
                      {backendTemple.tags.map((tag) => (
                        <span
                          key={tag}
                          className="text-xs px-2.5 py-1 rounded-full bg-primary/8 text-primary border border-primary/20"
                        >
                          {tag}
                        </span>
                      ))}
                    </div>
                  </div>
                )}

                {/* Entry restriction notice */}
                {backendTemple.nonHinduRestriction && (
                  <div className="flex items-start gap-3 p-3 rounded-lg bg-destructive/8 border border-destructive/20 mb-4">
                    <AlertTriangle className="w-4 h-4 text-destructive shrink-0 mt-0.5" />
                    <p className="text-sm text-destructive">
                      <span className="font-semibold">Entry Restriction:</span>{" "}
                      The inner sanctum (garbhagriha) of this temple is
                      restricted to Hindu devotees only. Non-Hindus may visit
                      the outer premises.
                    </p>
                  </div>
                )}

                {/* Contact info */}
                {(backendTemple.contactInfo?.phone ||
                  backendTemple.contactInfo?.email ||
                  backendTemple.contactInfo?.website) && (
                  <div>
                    <p className="text-xs text-muted-foreground uppercase tracking-wide mb-2 flex items-center gap-1">
                      <Users className="w-3.5 h-3.5" /> Contact Information
                    </p>
                    <div className="space-y-1.5">
                      {backendTemple.contactInfo?.phone && (
                        <a
                          href={`tel:${backendTemple.contactInfo.phone}`}
                          className="flex items-center gap-2 text-sm text-foreground hover:text-primary transition-colors"
                        >
                          <Phone className="w-4 h-4 text-primary" />
                          {backendTemple.contactInfo.phone}
                        </a>
                      )}
                      {backendTemple.contactInfo?.email && (
                        <a
                          href={`mailto:${backendTemple.contactInfo.email}`}
                          className="flex items-center gap-2 text-sm text-foreground hover:text-primary transition-colors"
                        >
                          <MessageSquare className="w-4 h-4 text-primary" />
                          {backendTemple.contactInfo.email}
                        </a>
                      )}
                      {backendTemple.contactInfo?.website && (
                        <a
                          href={backendTemple.contactInfo.website}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="flex items-center gap-2 text-sm text-foreground hover:text-primary transition-colors"
                        >
                          <Globe className="w-4 h-4 text-primary" />
                          {backendTemple.contactInfo.website}
                        </a>
                      )}
                    </div>
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Map section */}
            <div>
              <div className="flex flex-col sm:flex-row sm:items-center gap-3 mb-4">
                <h3 className="font-display text-base font-semibold text-foreground flex items-center gap-2">
                  <MapPin className="w-4 h-4 text-primary" /> Location &
                  Directions
                </h3>
                <div className="flex gap-2 sm:ml-auto">
                  <a
                    href={imagesHref}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1.5 text-xs font-medium h-8 px-3 rounded border border-amber-500/40 text-amber-700 hover:bg-amber-500/10 transition-colors"
                    data-ocid={`map-section-photos-${templeId}`}
                  >
                    <Image className="w-3.5 h-3.5" /> Photos
                  </a>
                  <a
                    href={mapsHref}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center gap-1.5 text-xs font-medium h-8 px-3 rounded border border-blue-500/40 text-blue-700 hover:bg-blue-500/10 transition-colors"
                    data-ocid={`map-section-maps-${templeId}`}
                  >
                    <MapPin className="w-3.5 h-3.5" /> Google Maps
                  </a>
                </div>
              </div>

              {/* Location badges */}
              <div className="flex flex-wrap gap-2 mb-3">
                <Badge
                  variant="secondary"
                  className="text-sm font-medium px-3 py-1"
                >
                  <MapPin className="w-3.5 h-3.5 mr-1.5 text-primary" />
                  {backendTemple.city}
                </Badge>
                <Badge
                  variant="secondary"
                  className="text-sm font-medium px-3 py-1"
                >
                  {backendTemple.state}
                </Badge>
              </div>

              <p className="text-sm text-muted-foreground mb-3 flex items-start gap-2">
                <Home className="w-4 h-4 text-primary shrink-0 mt-0.5" />
                {backendTemple.address}
              </p>

              <MapSection
                name={backendTemple.name}
                address={backendTemple.address}
                city={backendTemple.city}
                state={backendTemple.state}
              />
            </div>
          </motion.div>
        );

      case "timings":
        return (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-6"
          >
            <Card className="border-border shadow-warm-sm">
              <CardHeader className="pb-2">
                <CardTitle className="font-display text-lg flex items-center gap-2">
                  <Clock className="w-5 h-5 text-primary" /> Darshan Timings
                </CardTitle>
              </CardHeader>
              <CardContent>
                {darshanaTimings.length > 0 ? (
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                      <thead>
                        <tr className="border-b border-border bg-muted/40">
                          <th className="text-left px-3 py-3 font-semibold text-foreground">
                            Session
                          </th>
                          <th className="text-center px-3 py-3 font-semibold text-foreground">
                            Opens
                          </th>
                          <th className="text-center px-3 py-3 font-semibold text-foreground">
                            Closes
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        {darshanaTimings.map((slot) => (
                          <tr
                            key={slot.label}
                            className="border-b border-border hover:bg-muted/20 transition-smooth"
                          >
                            <td className="px-3 py-3 font-medium text-foreground">
                              {slot.label}
                            </td>
                            <td className="px-3 py-3 text-center text-primary font-semibold">
                              {slot.openTime}
                            </td>
                            <td className="px-3 py-3 text-center text-primary font-semibold">
                              {slot.closeTime}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                ) : (
                  <p className="text-sm text-muted-foreground">
                    Darshan timing details not available. Please contact the
                    temple directly.
                  </p>
                )}
                <p className="text-xs text-muted-foreground mt-3 flex items-center gap-1">
                  <AlertTriangle className="w-3 h-3" /> Timings may change on
                  special occasions. Verify with the temple office.
                </p>
              </CardContent>
            </Card>

            {poojas.length > 0 && (
              <Card className="border-border shadow-warm-sm">
                <CardHeader className="pb-2">
                  <CardTitle className="font-display text-lg flex items-center gap-2">
                    <Star className="w-5 h-5 text-primary" /> Daily Pooja
                    Schedule
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                  {poojas.map((pooja) => (
                    <div
                      key={pooja.name}
                      className="flex gap-4 p-3 rounded-lg bg-muted/30 hover:bg-muted/50 transition-smooth"
                      data-ocid={`pooja-item-${pooja.name}`}
                    >
                      <div className="text-center shrink-0">
                        <div className="bg-primary text-primary-foreground text-xs font-bold px-2 py-1 rounded-md">
                          {pooja.time}
                        </div>
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="font-semibold text-foreground text-sm">
                          {pooja.name}
                        </p>
                        <p className="text-xs text-muted-foreground mt-0.5 leading-snug">
                          {pooja.description}
                        </p>
                        {pooja.cost !== "Free" && (
                          <Badge variant="secondary" className="mt-1.5 text-xs">
                            {pooja.cost}
                          </Badge>
                        )}
                        {pooja.cost === "Free" && (
                          <span className="inline-block mt-1.5 text-xs text-primary font-medium">
                            Free
                          </span>
                        )}
                      </div>
                    </div>
                  ))}
                </CardContent>
              </Card>
            )}

            {backendTemple.specialDarshans.length > 0 && (
              <Card className="border-border shadow-warm-sm">
                <CardHeader className="pb-2">
                  <CardTitle className="font-display text-lg flex items-center gap-2">
                    <Star className="w-5 h-5 text-primary" /> Special Darshans
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                  {backendTemple.specialDarshans.map((sd) => (
                    <div
                      key={sd.name}
                      className="flex gap-4 p-3 rounded-lg bg-muted/30"
                    >
                      <div className="flex-1">
                        <p className="font-semibold text-foreground text-sm">
                          {sd.name}
                        </p>
                        <p className="text-xs text-muted-foreground mt-0.5">
                          {sd.description}
                        </p>
                        <p className="text-xs text-primary font-medium mt-1">
                          ₹{Number(sd.price).toLocaleString("en-IN")} ·
                          Available: {sd.availableDays.join(", ")}
                        </p>
                      </div>
                    </div>
                  ))}
                </CardContent>
              </Card>
            )}
          </motion.div>
        );

      case "festivals":
        return (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-4"
          >
            <p className="text-sm text-muted-foreground">
              Annual festivals and special observances at this temple.
            </p>
            {festivals.length === 0 ? (
              <div className="text-center py-10 text-muted-foreground">
                <Calendar className="w-10 h-10 mx-auto mb-3 opacity-40" />
                <p>No festival calendar available yet.</p>
              </div>
            ) : (
              <div className="space-y-3">
                {festivals.map((day) => (
                  <Card
                    key={day.name}
                    className="border-border shadow-warm-sm hover:shadow-warm-md transition-smooth"
                    data-ocid={`festival-card-${day.name}`}
                  >
                    <CardContent className="p-4 flex gap-4">
                      <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center shrink-0">
                        <Calendar className="w-5 h-5 text-primary" />
                      </div>
                      <div className="flex-1">
                        <p className="font-semibold text-foreground">
                          {day.name}
                        </p>
                        <p className="text-xs text-primary font-medium mt-0.5">
                          {day.date}
                        </p>
                        <p className="text-sm text-muted-foreground mt-1 leading-relaxed">
                          {day.description}
                        </p>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            )}
          </motion.div>
        );

      case "donations":
        return (
          <div id="donate">
            <DonationSection
              templeId={templeId}
              templeName={backendTemple.name}
              donationInfo={
                backendTemple.donationOptions.length > 0
                  ? `${backendTemple.donationOptions.length} seva option(s) available`
                  : "Donations support temple maintenance and community programs."
              }
              donationOptions={backendTemple.donationOptions}
            />
          </div>
        );

      case "nearby":
        return (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
          >
            <p className="text-sm text-muted-foreground mb-5">
              Curated list of places to visit, eat, and stay near{" "}
              {backendTemple.name}.
            </p>
            {nearbyPlaces.length === 0 ? (
              <div className="text-center py-10 text-muted-foreground">
                <MapPin className="w-10 h-10 mx-auto mb-3 opacity-40" />
                <p className="font-medium">Nearby places coming soon</p>
                <p className="text-sm mt-1">
                  We're curating hotels, restaurants, and attractions near this
                  temple.
                </p>
                <a
                  href={mapsHref}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-2 mt-4 text-sm font-medium text-blue-600 hover:underline"
                  data-ocid={`nearby-maps-link-${templeId}`}
                >
                  <MapPin className="w-4 h-4" />
                  Explore nearby on Google Maps
                  <ExternalLink className="w-3.5 h-3.5" />
                </a>
              </div>
            ) : (
              <NearbyPlaces places={nearbyPlaces as NearbyPlace[]} />
            )}
          </motion.div>
        );

      case "faqs":
        return (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-3"
          >
            <p className="text-sm text-muted-foreground mb-4">
              Frequently asked questions about visiting {backendTemple.name}.
            </p>
            <div className="text-center py-10 text-muted-foreground">
              <HelpCircle className="w-10 h-10 mx-auto mb-3 opacity-40" />
              <p>FAQs for this temple are being compiled.</p>
              <p className="text-sm mt-1">
                For questions, contact the temple directly.
              </p>
            </div>
          </motion.div>
        );

      case "reviews":
        return (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-6"
          >
            {allReviews.length > 0 && (
              <div className="flex items-center gap-4 p-4 rounded-xl bg-muted/30 border border-border">
                <div className="text-center">
                  <p className="font-display text-4xl font-bold text-primary">
                    {avgRating.toFixed(1)}
                  </p>
                  <StarRating
                    value={avgRating}
                    size="sm"
                    className="justify-center mt-1"
                  />
                  <p className="text-xs text-muted-foreground mt-1">
                    {allReviews.length} review
                    {allReviews.length !== 1 ? "s" : ""}
                  </p>
                </div>
                <Separator orientation="vertical" className="h-16" />
                <div className="flex-1 space-y-1.5">
                  {[5, 4, 3, 2, 1].map((star) => {
                    const count = allReviews.filter(
                      (r) => Math.round(r.rating) === star,
                    ).length;
                    const pct =
                      allReviews.length > 0
                        ? (count / allReviews.length) * 100
                        : 0;
                    return (
                      <div
                        key={star}
                        className="flex items-center gap-2 text-xs text-muted-foreground"
                      >
                        <span className="w-4 text-right">{star}★</span>
                        <div className="flex-1 h-1.5 bg-muted rounded-full overflow-hidden">
                          <div
                            className="h-full bg-primary rounded-full"
                            style={{ width: `${pct}%` }}
                          />
                        </div>
                        <span className="w-6">{count}</span>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            <div className="space-y-3" data-ocid="reviews-list">
              {allReviews.length === 0 && (
                <div
                  className="text-center py-10 text-muted-foreground"
                  data-ocid="reviews-empty"
                >
                  <MessageSquare className="w-10 h-10 mx-auto mb-3 opacity-40" />
                  <p className="font-medium">No reviews yet</p>
                  <p className="text-sm mt-1">
                    Be the first to share your experience!
                  </p>
                </div>
              )}
              {allReviews.map((review) => (
                <ReviewCard key={review.id} review={review} />
              ))}
            </div>

            <div className="border-t border-border pt-6">
              <h3 className="font-display text-base font-semibold text-foreground mb-4 flex items-center gap-2">
                <Star className="w-4 h-4 text-primary" /> Write a Review
              </h3>
              {!isAuthenticated ? (
                <div
                  className="text-center py-8 bg-muted/20 rounded-xl border border-border"
                  data-ocid="review-login-prompt"
                >
                  <p className="text-muted-foreground mb-4">
                    Please log in to share your experience
                  </p>
                  <Link to="/login">
                    <Button variant="outline" className="btn-accessible">
                      Log In to Review
                    </Button>
                  </Link>
                </div>
              ) : (
                <form
                  onSubmit={handleSubmitReview}
                  className="space-y-4"
                  data-ocid="review-form"
                >
                  <div>
                    <label
                      htmlFor="review-rating"
                      className="block text-sm font-medium text-foreground mb-2"
                    >
                      Your Rating
                    </label>
                    <div id="review-rating">
                      <StarRating
                        value={newRating}
                        size="lg"
                        interactive
                        onChange={setNewRating}
                        data-ocid="review-star-input"
                      />
                    </div>
                  </div>
                  <div>
                    <label
                      htmlFor="review-comment"
                      className="block text-sm font-medium text-foreground mb-2"
                    >
                      Your Review
                    </label>
                    <Textarea
                      id="review-comment"
                      placeholder="Share your experience visiting this temple — darshan, atmosphere, facilities…"
                      value={newComment}
                      onChange={(e) => setNewComment(e.target.value)}
                      className="min-h-[100px] resize-none"
                      data-ocid="review-comment-input"
                    />
                  </div>
                  <Button
                    type="submit"
                    disabled={submitting || newRating === 0}
                    className="btn-accessible gap-2"
                    data-ocid="review-submit-btn"
                  >
                    <Star className="w-4 h-4" />
                    {submitting ? "Submitting…" : "Submit Review"}
                  </Button>
                </form>
              )}
            </div>
          </motion.div>
        );

      default:
        return null;
    }
  };

  // ─── Render ────────────────────────────────────────────────────────────────

  return (
    <div className="min-h-screen bg-background" data-ocid="temple-detail-page">
      {/* Text-based hero banner — no image */}
      <div
        className="relative w-full overflow-hidden"
        style={{
          background: `linear-gradient(135deg, oklch(0.32 0.16 ${heroH1}), oklch(0.22 0.20 ${heroH2}))`,
        }}
      >
        {/* Subtle pattern overlay */}
        <div className="absolute inset-0 opacity-10 bg-[repeating-linear-gradient(45deg,oklch(0.9_0.05_90)_0_1px,transparent_1px_20px)]" />

        {/* Top action bar */}
        <div className="relative z-10 flex items-center justify-between px-4 pt-4 container mx-auto max-w-5xl">
          <Link
            to="/temples"
            search={{ q: "", nearby: "", state: "", category: "" }}
          >
            <Button
              variant="secondary"
              size="sm"
              className="gap-2 bg-white/15 backdrop-blur-sm hover:bg-white/25 text-white border-white/20"
              data-ocid="back-to-temples"
            >
              <ArrowLeft className="w-4 h-4" />
              <span className="hidden sm:inline">Back</span>
            </Button>
          </Link>

          <div className="flex gap-2">
            <Button
              variant="secondary"
              size="sm"
              onClick={handleShare}
              className="bg-white/15 backdrop-blur-sm hover:bg-white/25 text-white border-white/20 min-h-[40px] min-w-[40px] p-2"
              aria-label="Share temple"
              data-ocid="share-temple-btn"
            >
              <Share2 className="w-4 h-4" />
            </Button>
            <Button
              variant="secondary"
              size="sm"
              onClick={handleBookmark}
              className="bg-white/15 backdrop-blur-sm hover:bg-white/25 text-white border-white/20 min-h-[40px] min-w-[40px] p-2"
              aria-label={isBookmarked ? "Remove bookmark" : "Bookmark temple"}
              data-ocid="bookmark-temple-btn"
            >
              {isBookmarked ? (
                <BookmarkCheck className="w-4 h-4" />
              ) : (
                <Bookmark className="w-4 h-4" />
              )}
            </Button>
          </div>
        </div>

        {/* Breadcrumb + Title */}
        <div className="relative z-10 container mx-auto max-w-5xl px-4 pt-6 pb-8">
          <nav
            className="flex items-center gap-1 text-xs text-white/60 mb-4"
            aria-label="Breadcrumb"
          >
            <Link to="/" className="hover:text-white/90 transition-colors">
              Home
            </Link>
            <span>/</span>
            <Link
              to="/temples"
              search={{ q: "", nearby: "", state: "", category: "" }}
              className="hover:text-white/90 transition-colors"
            >
              Temples
            </Link>
            <span>/</span>
            <span className="text-white/90 truncate max-w-[200px]">
              {backendTemple.name}
            </span>
          </nav>

          {/* Temple icon + name */}
          <div className="flex items-start gap-4">
            <div className="w-16 h-16 rounded-2xl bg-white/15 backdrop-blur-sm flex items-center justify-center text-3xl shrink-0 shadow-lg">
              🛕
            </div>
            <div className="flex-1 min-w-0">
              <h1 className="font-display text-2xl md:text-4xl font-bold text-white leading-tight">
                {backendTemple.name}
              </h1>
              <p className="text-white/75 text-sm md:text-base mt-1">
                {backendTemple.deity}
              </p>
              <div className="flex flex-wrap gap-2 mt-3">
                <Badge className="bg-white/20 text-white border-white/30 backdrop-blur-sm text-xs">
                  {category}
                </Badge>
                <Badge className="bg-white/15 text-white border-white/25 backdrop-blur-sm text-xs">
                  <MapPin className="w-3 h-3 mr-1" />
                  {backendTemple.city}, {backendTemple.state}
                </Badge>
                {backendTemple.nonHinduRestriction && (
                  <Badge
                    className="bg-red-500/80 text-white border-0 text-xs flex items-center gap-1"
                    data-ocid="hindu-only-badge"
                  >
                    <AlertTriangle className="w-3 h-3" /> Hindus Only (Inner
                    Sanctum)
                  </Badge>
                )}
              </div>
            </div>
          </div>

          {/* Quick Google links in hero */}
          <div className="flex flex-wrap gap-2 mt-5">
            <a
              href={imagesHref}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1.5 text-xs font-medium h-9 px-4 rounded-full bg-white/15 text-white hover:bg-white/25 border border-white/25 backdrop-blur-sm transition-colors"
              data-ocid={`hero-photos-link-${templeId}`}
            >
              <Image className="w-3.5 h-3.5" />
              View Photos on Google
            </a>
            <a
              href={mapsHref}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1.5 text-xs font-medium h-9 px-4 rounded-full bg-white/15 text-white hover:bg-white/25 border border-white/25 backdrop-blur-sm transition-colors"
              data-ocid={`hero-maps-link-${templeId}`}
            >
              <MapPin className="w-3.5 h-3.5" />
              View on Google Maps
            </a>
          </div>
        </div>
      </div>

      {/* Location bar */}
      <div className="bg-card border-b border-border">
        <div className="container mx-auto max-w-5xl px-4 py-3 flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <MapPin className="w-4 h-4 text-primary shrink-0" />
            <span>
              {backendTemple.city}, {backendTemple.state}
            </span>
          </div>
          <div className="flex items-center gap-4 text-sm">
            {allReviews.length > 0 && (
              <div className="flex items-center gap-1.5">
                <StarRating value={avgRating} size="sm" />
                <span className="font-medium text-foreground">
                  {avgRating.toFixed(1)}
                </span>
                <span className="text-muted-foreground">
                  ({allReviews.length})
                </span>
              </div>
            )}
            {darshanaTimings.length > 0 && (
              <div className="flex items-center gap-1.5 text-muted-foreground">
                <Clock className="w-3.5 h-3.5" />
                <span className="text-xs">
                  {darshanaTimings[0]?.openTime} –{" "}
                  {darshanaTimings[darshanaTimings.length - 1]?.closeTime}
                </span>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Description */}
      <div className="bg-muted/30 border-b border-border">
        <div className="container mx-auto max-w-5xl px-4 py-4">
          <p className="text-sm md:text-base text-foreground leading-relaxed">
            {backendTemple.description}
          </p>
        </div>
      </div>

      {/* Tab navigation — sticky */}
      <div className="sticky top-0 z-20 bg-card shadow-warm-sm">
        <div className="container mx-auto max-w-5xl">
          <TabNav tabs={TABS} active={activeTab} onChange={setActiveTab} />
        </div>
      </div>

      {/* Tab content */}
      <div
        className="container mx-auto max-w-5xl px-4 py-8"
        id={`tabpanel-${activeTab}`}
        role="tabpanel"
      >
        {renderTab()}
      </div>

      {/* Contact & links footer card */}
      <div className="bg-muted/40 border-t border-border">
        <div className="container mx-auto max-w-5xl px-4 py-6">
          <div className="flex flex-wrap gap-4 text-sm text-muted-foreground">
            {backendTemple.contactInfo?.phone && (
              <a
                href={`tel:${backendTemple.contactInfo.phone}`}
                className="flex items-center gap-1.5 hover:text-foreground transition-smooth"
              >
                <Phone className="w-4 h-4" /> {backendTemple.contactInfo.phone}
              </a>
            )}
            {!backendTemple.contactInfo?.phone && (
              <a
                href="tel:+91"
                className="flex items-center gap-1.5 hover:text-foreground transition-smooth"
              >
                <Phone className="w-4 h-4" /> Contact Temple Office
              </a>
            )}
            {backendTemple.contactInfo?.website ? (
              <a
                href={backendTemple.contactInfo.website}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-1.5 hover:text-foreground transition-smooth"
              >
                <Globe className="w-4 h-4" /> Official Website
              </a>
            ) : (
              <a
                href={`https://www.google.com/search?q=${encodeURIComponent(`${backendTemple.name} official website`)}`}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-1.5 hover:text-foreground transition-smooth"
              >
                <Globe className="w-4 h-4" /> Search Online
              </a>
            )}
            <a
              href={imagesHref}
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-1.5 hover:text-foreground transition-smooth text-amber-600"
            >
              <Image className="w-4 h-4" /> View Photos on Google
            </a>
            <a
              href={mapsHref}
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-1.5 hover:text-foreground transition-smooth text-blue-600"
            >
              <MapPin className="w-4 h-4" /> View on Google Maps
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}
