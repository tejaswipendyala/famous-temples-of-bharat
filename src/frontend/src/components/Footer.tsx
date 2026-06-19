import { Link } from "@tanstack/react-router";
import { Flame, MapPin } from "lucide-react";

export default function Footer() {
  const year = new Date().getFullYear();
  const hostname =
    typeof window !== "undefined" ? window.location.hostname : "";
  const caffeineUrl = `https://caffeine.ai?utm_source=caffeine-footer&utm_medium=referral&utm_content=${encodeURIComponent(hostname)}`;

  return (
    <footer className="bg-card border-t border-border mt-auto">
      <div className="container mx-auto px-4 py-10">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 mb-8">
          {/* Brand */}
          <div className="lg:col-span-2">
            <div className="flex items-center gap-2 mb-3">
              <div className="w-9 h-9 rounded-full bg-primary flex items-center justify-center">
                <Flame className="w-5 h-5 text-primary-foreground" />
              </div>
              <div>
                <div className="font-display font-bold text-base text-foreground">
                  Famous Temples of Bharat
                </div>
              </div>
            </div>
            <p className="text-sm text-muted-foreground leading-relaxed max-w-xs">
              Discover India's most sacred temples — their history, timings,
              poojas, and spiritual heritage. Plan your pilgrimage with ease.
            </p>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="font-display font-semibold text-sm text-foreground mb-3 uppercase tracking-wide">
              Explore
            </h4>
            <ul className="space-y-2">
              {[
                { label: "Home", to: "/" },
                { label: "Search Temples", to: "/temples" },
                { label: "Login", to: "/login" },
                { label: "Register", to: "/register" },
              ].map((link) => (
                <li key={link.to}>
                  <Link
                    to={link.to}
                    className="text-sm text-muted-foreground hover:text-primary transition-colors"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="font-display font-semibold text-sm text-foreground mb-3 uppercase tracking-wide">
              Contact
            </h4>
            <ul className="space-y-2">
              <li className="flex items-center gap-2 text-sm text-muted-foreground">
                <MapPin className="w-4 h-4 shrink-0 text-accent" />
                <span>India</span>
              </li>
              <li className="flex items-start gap-2 text-sm text-muted-foreground">
                <MapPin
                  className="w-4 h-4 shrink-0 text-accent mt-0.5 opacity-0"
                  aria-hidden="true"
                />
                <span>Contact available at your nearest temple office</span>
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t border-border pt-6 flex flex-col sm:flex-row items-center justify-between gap-3 text-xs text-muted-foreground">
          <p>© {year} Famous Temples of Bharat. All rights reserved.</p>
          <p>
            Built with love using{" "}
            <a
              href={caffeineUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="text-primary hover:underline"
            >
              caffeine.ai
            </a>
          </p>
        </div>
      </div>
    </footer>
  );
}
