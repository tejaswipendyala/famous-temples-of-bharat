import { cn } from "@/lib/utils";
import { Star } from "lucide-react";

interface StarRatingProps {
  value: number;
  max?: number;
  size?: "sm" | "md" | "lg";
  interactive?: boolean;
  onChange?: (rating: number) => void;
  className?: string;
}

const sizeClasses = {
  sm: "w-3.5 h-3.5",
  md: "w-5 h-5",
  lg: "w-6 h-6",
};

export default function StarRating({
  value,
  max = 5,
  size = "md",
  interactive = false,
  onChange,
  className,
}: StarRatingProps) {
  return (
    <div
      className={cn("flex items-center gap-0.5", className)}
      role={interactive ? "radiogroup" : "img"}
      aria-label={`Rating: ${value} out of ${max} stars`}
    >
      {Array.from({ length: max }, (_, i) => {
        const filled = i < Math.round(value);
        const starNum = i + 1;
        return (
          <button
            key={`star-${starNum}`}
            type="button"
            disabled={!interactive}
            onClick={() => interactive && onChange?.(i + 1)}
            className={cn(
              "transition-smooth focus-ring rounded-sm",
              interactive
                ? "cursor-pointer hover:scale-110"
                : "cursor-default pointer-events-none",
              !interactive && "disabled:pointer-events-none",
            )}
            aria-label={`${i + 1} star`}
          >
            <Star
              className={cn(
                sizeClasses[size],
                filled
                  ? "fill-primary text-primary"
                  : "fill-muted text-muted-foreground",
              )}
            />
          </button>
        );
      })}
    </div>
  );
}
