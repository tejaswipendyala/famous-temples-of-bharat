import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Search, X } from "lucide-react";
import { useRef } from "react";

interface SearchBarProps {
  value: string;
  onChange: (val: string) => void;
  placeholder?: string;
}

export default function SearchBar({
  value,
  onChange,
  placeholder = "Search by temple name, deity, city, or keyword…",
}: SearchBarProps) {
  const inputRef = useRef<HTMLInputElement>(null);

  return (
    <div className="relative w-full group">
      <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground pointer-events-none transition-colors group-focus-within:text-primary" />
      <Input
        ref={inputRef}
        type="search"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        data-ocid="search-input"
        className="pl-12 pr-12 h-14 text-base rounded-xl border-2 border-border focus:border-primary bg-card shadow-warm-sm transition-smooth placeholder:text-muted-foreground/70"
        aria-label="Search temples"
      />
      {value && (
        <Button
          type="button"
          variant="ghost"
          size="icon"
          aria-label="Clear search"
          onClick={() => {
            onChange("");
            inputRef.current?.focus();
          }}
          className="absolute right-2 top-1/2 -translate-y-1/2 h-10 w-10 rounded-lg text-muted-foreground hover:text-foreground hover:bg-muted/60"
          data-ocid="search-clear"
        >
          <X className="w-4 h-4" />
        </Button>
      )}
    </div>
  );
}
