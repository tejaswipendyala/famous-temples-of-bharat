import { Button } from "@/components/ui/button";
import { ExternalLink, MapPin, Navigation } from "lucide-react";
import { useState } from "react";

interface MapSectionProps {
  name: string;
  address: string;
  city?: string;
  state?: string;
  latitude?: number;
  longitude?: number;
}

export default function MapSection({
  name,
  address,
  city,
  state,
}: MapSectionProps) {
  const [gettingLocation, setGettingLocation] = useState(false);
  const [userCoords, setUserCoords] = useState<{
    lat: number;
    lng: number;
  } | null>(null);
  const [locationError, setLocationError] = useState<string | null>(null);

  // Build a descriptive destination string from available info
  const destinationQuery = [name, address, city, state]
    .filter(Boolean)
    .join(", ");

  const openDirections = (origin?: string) => {
    const dest = encodeURIComponent(destinationQuery);
    const base = "https://www.google.com/maps/dir/";
    const url = origin
      ? `${base}${encodeURIComponent(origin)}/${dest}`
      : `${base}/${dest}`;
    window.open(url, "_blank", "noopener,noreferrer");
  };

  const handleGetDirections = () => {
    setGettingLocation(true);
    setLocationError(null);

    if (!navigator.geolocation) {
      setLocationError("Geolocation is not supported by your browser.");
      setGettingLocation(false);
      openDirections();
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const { latitude: lat, longitude: lng } = pos.coords;
        setUserCoords({ lat, lng });
        setGettingLocation(false);
        openDirections(`${lat},${lng}`);
      },
      () => {
        setGettingLocation(false);
        setLocationError(
          "Unable to get your location. Opening directions without origin.",
        );
        openDirections();
      },
      { timeout: 8000, maximumAge: 60000 },
    );
  };

  const mapsSearchUrl = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(destinationQuery)}`;

  // Google Maps embed using place search (no API key required for search embeds)
  const embedUrl = `https://maps.google.com/maps?q=${encodeURIComponent(destinationQuery)}&output=embed&z=14`;

  return (
    <section className="rounded-xl overflow-hidden border border-border bg-card shadow-warm-sm">
      {/* Embedded Google Maps iframe */}
      <div className="relative w-full h-64 overflow-hidden bg-muted/30">
        <iframe
          title={`Map showing location of ${name}`}
          src={embedUrl}
          width="100%"
          height="100%"
          style={{ border: 0 }}
          allowFullScreen
          loading="lazy"
          referrerPolicy="no-referrer-when-downgrade"
          className="w-full h-full"
        />
        {/* Open in Google Maps overlay button */}
        <a
          href={mapsSearchUrl}
          target="_blank"
          rel="noopener noreferrer"
          className="absolute top-3 right-3 flex items-center gap-1.5 bg-card/90 backdrop-blur-sm text-xs font-medium text-foreground px-2.5 py-1.5 rounded-lg shadow-warm-sm hover:bg-card transition-smooth"
          aria-label="Open in Google Maps"
          data-ocid="open-maps-link"
        >
          <ExternalLink className="w-3.5 h-3.5" />
          Open in Maps
        </a>
      </div>

      {/* Controls */}
      <div className="p-4 flex flex-col sm:flex-row items-start sm:items-center gap-3">
        <div className="flex-1 min-w-0">
          <div className="flex items-start gap-2">
            <MapPin className="w-4 h-4 text-primary shrink-0 mt-0.5" />
            <p className="text-sm text-muted-foreground break-words">
              {address}
              {city && `, ${city}`}
              {state && `, ${state}`}
            </p>
          </div>
          {userCoords && (
            <p className="text-xs text-primary mt-1 flex items-center gap-1">
              <Navigation className="w-3 h-3" />
              Directions from your current location
            </p>
          )}
          {locationError && (
            <p className="text-xs text-destructive mt-1">{locationError}</p>
          )}
        </div>
        <Button
          onClick={handleGetDirections}
          disabled={gettingLocation}
          data-ocid="get-directions-btn"
          className="btn-accessible shrink-0 gap-2"
        >
          <Navigation className="w-4 h-4" />
          {gettingLocation ? "Getting location…" : "Get Directions"}
        </Button>
      </div>
    </section>
  );
}
