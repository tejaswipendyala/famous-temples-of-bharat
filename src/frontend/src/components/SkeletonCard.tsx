import { Skeleton } from "@/components/ui/skeleton";

export default function SkeletonCard() {
  return (
    <div className="bg-card border border-border rounded-xl overflow-hidden flex flex-col">
      <Skeleton className="aspect-[4/3] w-full rounded-none" />
      <div className="p-4 flex flex-col gap-3">
        <Skeleton className="h-4 w-3/4 rounded" />
        <Skeleton className="h-3 w-1/2 rounded" />
        <Skeleton className="h-3 w-2/3 rounded" />
        <Skeleton className="h-3 w-1/3 rounded" />
        <div className="flex gap-2 mt-2">
          <Skeleton className="h-10 flex-1 rounded-lg" />
          <Skeleton className="h-10 flex-1 rounded-lg" />
        </div>
      </div>
    </div>
  );
}
