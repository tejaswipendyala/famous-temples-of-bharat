import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Link, useNavigate } from "@tanstack/react-router";
import {
  ArrowRight,
  CalendarDays,
  ChevronDown,
  Clock,
  Compass,
  Heart,
  MapPin,
  Search,
  Star,
  Sun,
} from "lucide-react";
import { motion } from "motion/react";
import { useRef, useState } from "react";
import TempleCard from "../components/TempleCard";
import {
  INDIA_STATES_WITH_COUNTS,
  useFeaturedTemples,
  useTempleOfTheDay,
} from "../hooks/useTemples";

const WHY_VISIT = [
  {
    icon: <MapPin className="w-7 h-7 text-primary" />,
    title: "Navigate with Ease",
    description:
      "Get turn-by-turn directions from your current location to any temple across Bharat.",
  },
  {
    icon: <Clock className="w-7 h-7 text-accent" />,
    title: "Real-Time Schedules",
    description:
      "Accurate darshan timings, pooja schedules, and special day calendars — always up to date.",
  },
  {
    icon: <Star className="w-7 h-7 text-primary" />,
    title: "Verified Information",
    description:
      "Temple histories, donation details, and facility information curated by devotees.",
  },
  {
    icon: <Compass className="w-7 h-7 text-accent" />,
    title: "Explore Nearby",
    description:
      "Discover hotels, restaurants, museums, and attractions near every temple.",
  },
  {
    icon: <Heart className="w-7 h-7 text-primary" />,
    title: "Easy Donations",
    description:
      "Support temples you love with secure online donations via Stripe payment integration.",
  },
];

const GENERAL_FAQS = [
  {
    q: "How do I find temples near me?",
    a: "Use the 'Use Current Location' feature on the Explore page. We'll show you temples sorted by proximity using your device location.",
  },
  {
    q: "Are darshan timings always accurate?",
    a: "We strive to keep timings current, but festivals and special occasions may change them. We recommend calling the temple directly for same-day visits.",
  },
  {
    q: "Can I book poojas online?",
    a: "Some temples offer online booking through their official portals. We link to those where available on the temple detail page.",
  },
  {
    q: "What is a Jyotirlinga?",
    a: "Jyotirlingas are 12 sacred shrines dedicated to Lord Shiva where he appeared as a pillar of light. They are among the holiest sites in Hinduism.",
  },
  {
    q: "How do I contribute information about a temple?",
    a: "Register an account and visit the temple's page. You can submit updates, reviews, or new information for admin review.",
  },
];

// Abbreviate long state/UT names for compact display on small cards
function stateAbbr(name: string): string {
  const MAP: Record<string, string> = {
    "Andaman & Nicobar Islands": "A&N Islands",
    "Dadra & Nagar Haveli": "Dadra & NH",
  };
  return MAP[name] ?? name;
}

export default function HomePage() {
  const [searchQuery, setSearchQuery] = useState("");
  const [openFaq, setOpenFaq] = useState<number | null>(null);
  const navigate = useNavigate();
  const { temples, toggleBookmark } = useFeaturedTemples();
  const templeOfTheDay = useTempleOfTheDay();
  const featuredRef = useRef<HTMLElement>(null);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    navigate({
      to: "/temples",
      search: { q: searchQuery.trim(), nearby: "", state: "", category: "" },
    });
  };

  const handleLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        () =>
          navigate({
            to: "/temples",
            search: { q: "", nearby: "true", state: "", category: "" },
          }),
        () =>
          navigate({
            to: "/temples",
            search: { q: "", nearby: "", state: "", category: "" },
          }),
      );
    } else {
      navigate({
        to: "/temples",
        search: { q: "", nearby: "", state: "", category: "" },
      });
    }
  };

  const todayDescription = templeOfTheDay
    ? (templeOfTheDay.description ?? templeOfTheDay.name)
    : "";

  // Two sentences from description for the spotlight
  const descSentences = todayDescription.split(". ").slice(0, 2).join(". ");
  const spotlightDesc =
    descSentences + (descSentences.endsWith(".") ? "" : ".");

  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section
        className="relative min-h-[85vh] flex flex-col items-center justify-center overflow-hidden"
        style={{
          backgroundImage:
            "url('/assets/generated/temple-hero.dim_1200x600.jpg')",
          backgroundSize: "cover",
          backgroundPosition: "center top",
        }}
      >
        {/* Overlay */}
        <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-black/40 to-black/70" />

        <div className="relative z-10 flex flex-col items-center text-center px-4 py-16 max-w-4xl mx-auto w-full gap-6">
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <Badge className="bg-primary/20 text-primary-foreground border-primary/40 backdrop-blur-sm text-sm px-4 py-1 mb-4">
              🪔 Discover Sacred Bharat
            </Badge>
          </motion.div>

          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.1 }}
            className="font-display font-bold text-4xl sm:text-5xl md:text-6xl text-white leading-tight"
          >
            Famous Temples
            <br />
            <span className="text-primary">of Bharat</span>
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.2 }}
            className="text-lg sm:text-xl text-white/85 max-w-2xl leading-relaxed"
          >
            Explore India's most revered temples — their divine history, darshan
            schedules, sacred poojas, and spiritual significance, all in one
            place.
          </motion.p>

          {/* Search Bar */}
          <motion.form
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.3 }}
            onSubmit={handleSearch}
            className="w-full max-w-2xl"
          >
            <div className="flex gap-2 bg-card/95 backdrop-blur-sm rounded-xl p-2 shadow-warm-lg border border-border">
              <div className="flex-1 flex items-center gap-2 px-3">
                <Search className="w-5 h-5 text-muted-foreground shrink-0" />
                <Input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search temples, states, deities..."
                  className="border-0 bg-transparent focus-visible:ring-0 text-base placeholder:text-muted-foreground h-10 px-0"
                  data-ocid="hero-search-input"
                />
              </div>
              <Button
                type="submit"
                className="btn-accessible bg-primary text-primary-foreground hover:bg-primary/90 rounded-lg px-6 shrink-0"
                data-ocid="hero-search-submit"
              >
                Search
              </Button>
            </div>
          </motion.form>

          {/* Location CTA */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.7, delay: 0.4 }}
            className="flex flex-col sm:flex-row items-center gap-3"
          >
            <Button
              variant="outline"
              className="bg-card/30 backdrop-blur-sm border-white/30 text-white hover:bg-white/10 hover:text-white btn-accessible gap-2"
              onClick={handleLocation}
              data-ocid="btn-use-location"
            >
              <MapPin className="w-5 h-5" />
              Use Current Location
            </Button>
            <Button
              variant="ghost"
              type="button"
              onClick={() =>
                featuredRef.current?.scrollIntoView({ behavior: "smooth" })
              }
              className="text-white/80 hover:text-white hover:bg-white/10 btn-accessible gap-2"
              data-ocid="btn-explore-all"
            >
              Explore All Temples <ArrowRight className="w-4 h-4" />
            </Button>
          </motion.div>
        </div>

        {/* Scroll indicator */}
        <motion.div
          animate={{ y: [0, 8, 0] }}
          transition={{ repeat: Number.POSITIVE_INFINITY, duration: 2 }}
          className="absolute bottom-8 left-1/2 -translate-x-1/2 text-white/60"
        >
          <ChevronDown className="w-6 h-6" />
        </motion.div>
      </section>

      {/* Browse by State Section */}
      <section
        className="bg-muted/30 border-b border-border py-14 px-4"
        data-ocid="browse-by-state-section"
      >
        <div className="container mx-auto">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-8">
            <div>
              <h2 className="font-display font-bold text-3xl text-foreground mb-1">
                Browse by State
              </h2>
              <p className="text-muted-foreground">
                Discover temples across all 36 states and union territories of
                India
              </p>
            </div>
            <Button
              asChild
              variant="outline"
              className="border-primary/40 text-primary hover:bg-primary/10 btn-accessible gap-2 shrink-0"
              data-ocid="browse-state-view-all"
            >
              <a href="/temples">
                View All Temples <ArrowRight className="w-4 h-4" />
              </a>
            </Button>
          </div>

          <div
            className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3"
            data-ocid="state-grid"
          >
            {INDIA_STATES_WITH_COUNTS.map((stateItem, i) => (
              <motion.div
                key={stateItem.name}
                initial={{ opacity: 0, scale: 0.95 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ duration: 0.3, delay: i * 0.02 }}
              >
                <Link
                  to="/temples"
                  search={{
                    q: "",
                    nearby: "",
                    state: stateItem.name,
                    category: "",
                  }}
                  className="block"
                  data-ocid={`state-card.${i + 1}`}
                >
                  <div className="bg-card border border-border rounded-xl p-3.5 flex flex-col gap-1 hover:border-primary/40 hover:shadow-warm-md hover:bg-primary/5 transition-smooth cursor-pointer group">
                    <span className="font-display font-semibold text-sm text-foreground leading-snug group-hover:text-primary transition-colors line-clamp-2">
                      {stateAbbr(stateItem.name)}
                    </span>
                    <span className="text-xs text-muted-foreground">
                      {stateItem.count} temple{stateItem.count !== 1 ? "s" : ""}
                    </span>
                  </div>
                </Link>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Temple of the Day Spotlight */}
      {templeOfTheDay && (
        <section
          className="bg-background py-14 px-4 border-b border-border"
          data-ocid="temple-of-the-day-section"
        >
          <div className="container mx-auto max-w-5xl">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-10 h-10 rounded-full bg-primary/15 flex items-center justify-center shrink-0">
                <Sun className="w-5 h-5 text-primary" />
              </div>
              <div>
                <h2 className="font-display font-bold text-3xl text-foreground leading-tight">
                  Temple of the Day
                </h2>
                <p className="text-muted-foreground text-sm">
                  Today's sacred spotlight — refreshes every day
                </p>
              </div>
            </div>

            <motion.div
              initial={{ opacity: 0, y: 24 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6 }}
              className="bg-card border border-border rounded-2xl overflow-hidden shadow-warm-lg flex flex-col md:flex-row"
              data-ocid="temple-of-the-day-card"
            >
              {/* Gradient banner replacing image */}
              <div
                className="md:w-2/5 relative aspect-[4/3] md:aspect-auto overflow-hidden shrink-0 flex flex-col items-center justify-center gap-3"
                style={{
                  background:
                    "linear-gradient(135deg, oklch(0.50 0.20 35), oklch(0.38 0.24 55))",
                }}
              >
                <div className="absolute inset-0 opacity-10 bg-[repeating-linear-gradient(45deg,oklch(0.9_0.05_90)_0_1px,transparent_1px_20px)]" />
                <span
                  className="relative text-5xl"
                  role="img"
                  aria-label="temple"
                >
                  🛕
                </span>
                <span className="relative text-sm font-medium text-white/80">
                  {templeOfTheDay.deity}
                </span>
                <div className="absolute top-4 left-4">
                  <Badge className="bg-primary/90 text-primary-foreground border-0 shadow-warm-sm text-xs px-3 py-1 font-medium">
                    🌟 Today's Spotlight
                  </Badge>
                </div>
              </div>

              {/* Content */}
              <div className="flex flex-col p-6 md:p-8 gap-4 flex-1 justify-center">
                <div>
                  <Badge
                    variant="outline"
                    className="border-primary/30 text-primary text-xs mb-3"
                  >
                    {templeOfTheDay.category}
                  </Badge>
                  <h3 className="font-display font-bold text-2xl md:text-3xl text-foreground leading-tight mb-1">
                    {templeOfTheDay.name}
                  </h3>
                  <p className="text-accent font-medium text-sm">
                    {templeOfTheDay.deity}
                  </p>
                </div>

                <div className="flex items-center gap-2 text-muted-foreground text-sm">
                  <MapPin className="w-4 h-4 shrink-0 text-primary" />
                  <span>
                    {templeOfTheDay.city}, {templeOfTheDay.state}
                  </span>
                </div>

                {templeOfTheDay.darshanaTimings[0] && (
                  <div className="flex items-center gap-2 text-muted-foreground text-sm">
                    <Clock className="w-4 h-4 shrink-0 text-primary" />
                    <span>
                      Darshan: {templeOfTheDay.darshanaTimings[0].openTime} –{" "}
                      {templeOfTheDay.darshanaTimings[0].closeTime}
                    </span>
                  </div>
                )}

                <p className="text-muted-foreground text-sm leading-relaxed border-l-2 border-primary/40 pl-4 italic">
                  {spotlightDesc}
                </p>

                <div className="flex flex-col sm:flex-row gap-3 mt-2">
                  <Button
                    asChild
                    className="btn-accessible bg-primary text-primary-foreground hover:bg-primary/90 gap-2"
                    data-ocid="temple-of-the-day-view-details"
                  >
                    <Link to="/temples/$id" params={{ id: templeOfTheDay.id }}>
                      View Full Details <ArrowRight className="w-4 h-4" />
                    </Link>
                  </Button>
                  <Button
                    asChild
                    variant="outline"
                    className="btn-accessible border-primary/30 text-primary hover:bg-primary/10 gap-2"
                    data-ocid="temple-of-the-day-calendar"
                  >
                    <Link to="/temples/$id" params={{ id: templeOfTheDay.id }}>
                      <CalendarDays className="w-4 h-4" />
                      Festival Calendar
                    </Link>
                  </Button>
                </div>
              </div>
            </motion.div>
          </div>
        </section>
      )}

      {/* Map / Location Banner */}
      <section className="bg-muted/30 border-b border-border py-10 px-4">
        <div className="container mx-auto max-w-4xl flex flex-col sm:flex-row items-center gap-6 justify-between">
          <div className="flex-1">
            <h2 className="font-display font-bold text-2xl text-foreground mb-1">
              Find Temples Near You
            </h2>
            <p className="text-muted-foreground text-base">
              Enable location to discover sacred sites close to you, with
              directions from your doorstep.
            </p>
          </div>
          <div className="shrink-0 flex flex-col items-center gap-3">
            {/* Map preview illustration */}
            <div className="w-48 h-28 rounded-xl bg-card border border-border overflow-hidden relative flex items-center justify-center shadow-warm-md">
              <div className="absolute inset-0 opacity-20 bg-[repeating-linear-gradient(45deg,oklch(var(--muted))_0_10px,transparent_10px_20px)]" />
              <div className="relative flex flex-col items-center gap-2">
                <MapPin className="w-8 h-8 text-primary" />
                <span className="text-xs text-muted-foreground font-medium">
                  Interactive Map
                </span>
              </div>
            </div>
            <Button
              onClick={handleLocation}
              className="btn-accessible bg-primary text-primary-foreground hover:bg-primary/90 gap-2"
              data-ocid="map-use-location"
            >
              <MapPin className="w-5 h-5" />
              Use Current Location
            </Button>
          </div>
        </div>
      </section>

      {/* Featured Temples */}
      <section
        ref={featuredRef}
        id="featured"
        className="bg-background py-14 px-4"
      >
        <div className="container mx-auto">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-8">
            <div>
              <h2 className="font-display font-bold text-3xl text-foreground mb-1">
                Featured Temple Cards
              </h2>
              <p className="text-muted-foreground">
                Explore some of India's most beloved sacred sites
              </p>
            </div>
            <Button
              asChild
              variant="outline"
              className="border-primary/40 text-primary hover:bg-primary/10 btn-accessible gap-2 shrink-0"
              data-ocid="btn-view-all-temples"
            >
              <a href="/temples">
                View All <ArrowRight className="w-4 h-4" />
              </a>
            </Button>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {temples.slice(0, 6).map((temple, i) => (
              <motion.div
                key={temple.id}
                initial={{ opacity: 0, y: 24 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.08 }}
              >
                <TempleCard temple={temple} onBookmark={toggleBookmark} />
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Why Visit Section */}
      <section className="bg-muted/30 py-14 px-4">
        <div className="container mx-auto">
          <div className="text-center mb-10">
            <h2 className="font-display font-bold text-3xl text-foreground mb-2">
              Why Use Famous Temples of Bharat?
            </h2>
            <p className="text-muted-foreground max-w-xl mx-auto">
              Your complete companion for pilgrimage planning across India
            </p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6">
            {WHY_VISIT.map((item, i) => (
              <motion.div
                key={item.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.1 }}
                className="bg-card border border-border rounded-xl p-6 flex flex-col gap-3 hover:shadow-warm-md transition-smooth"
              >
                <div className="w-12 h-12 rounded-full bg-secondary flex items-center justify-center">
                  {item.icon}
                </div>
                <h3 className="font-display font-semibold text-base text-foreground">
                  {item.title}
                </h3>
                <p className="text-sm text-muted-foreground leading-relaxed">
                  {item.description}
                </p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* FAQ Section */}
      <section className="bg-background py-14 px-4">
        <div className="container mx-auto max-w-3xl">
          <div className="text-center mb-10">
            <h2 className="font-display font-bold text-3xl text-foreground mb-2">
              Frequently Asked Questions
            </h2>
            <p className="text-muted-foreground">
              Quick answers to common questions about our platform
            </p>
          </div>
          <div className="flex flex-col gap-3" data-ocid="faq-list">
            {GENERAL_FAQS.map((faq, i) => (
              <div
                key={faq.q}
                className="bg-card border border-border rounded-xl overflow-hidden"
                data-ocid={`faq-item-${i}`}
              >
                <button
                  type="button"
                  onClick={() => setOpenFaq(openFaq === i ? null : i)}
                  className="w-full flex items-center justify-between gap-4 px-5 py-4 text-left text-base font-medium text-foreground hover:bg-muted/50 transition-colors focus-ring"
                  aria-expanded={openFaq === i}
                >
                  <span>{faq.q}</span>
                  <ChevronDown
                    className={`w-5 h-5 text-muted-foreground shrink-0 transition-transform duration-200 ${openFaq === i ? "rotate-180" : ""}`}
                  />
                </button>
                {openFaq === i && (
                  <div className="px-5 pb-4 text-sm text-muted-foreground leading-relaxed border-t border-border pt-3">
                    {faq.a}
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Banner */}
      <section className="bg-primary/10 border-y border-primary/20 py-14 px-4">
        <div className="container mx-auto max-w-2xl text-center flex flex-col items-center gap-5">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
          >
            <h2 className="font-display font-bold text-3xl text-foreground mb-2">
              Begin Your Spiritual Journey
            </h2>
            <p className="text-muted-foreground text-base">
              Create a free account to save your favourite temples, track
              visits, and get personalised pilgrimage recommendations.
            </p>
          </motion.div>
          <div className="flex flex-col sm:flex-row gap-3">
            <Button
              asChild
              className="btn-accessible bg-primary text-primary-foreground hover:bg-primary/90 text-base px-8"
              data-ocid="cta-register"
            >
              <a href="/register">Register for Free</a>
            </Button>
            <Button
              asChild
              variant="outline"
              className="btn-accessible border-primary/30 text-primary hover:bg-primary/10 text-base px-8"
              data-ocid="cta-explore"
            >
              <a href="/temples">Explore Temples</a>
            </Button>
          </div>
        </div>
      </section>
    </div>
  );
}
