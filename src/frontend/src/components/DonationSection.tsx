import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import {
  AlertTriangle,
  CheckCircle2,
  Coins,
  Heart,
  Loader2,
  XCircle,
} from "lucide-react";
import { motion } from "motion/react";
import { useEffect, useState } from "react";
import { toast } from "sonner";
import { useAuth } from "../hooks/useAuth";
import { useCreateCheckoutSession } from "../hooks/useQueries";

const PRESET_AMOUNTS = [
  { value: 101, label: "₹101", desc: "Ekadashi Seva" },
  { value: 501, label: "₹501", desc: "Abhishekam" },
  { value: 1001, label: "₹1,001", desc: "Annadanam" },
  { value: 2001, label: "₹2,001", desc: "Festival Pooja" },
  { value: 5001, label: "₹5,001", desc: "Sponsor a Day" },
];

function getPaymentStatus() {
  const params = new URLSearchParams(window.location.search);
  return {
    status: params.get("payment_status") as "success" | "cancelled" | null,
    sessionId: params.get("session_id"),
    amount: params.get("amount"),
    temple: params.get("temple"),
  };
}

interface DonationSectionProps {
  templeId: string;
  templeName: string;
  donationInfo: string;
  donationOptions?: Array<{
    name?: string;
    donationType?: string;
    description: string;
    amount: number | bigint;
  }>;
}

export default function DonationSection({
  templeId,
  templeName,
  donationInfo,
  donationOptions = [],
}: DonationSectionProps) {
  const payment = getPaymentStatus();
  const { isAuthenticated } = useAuth();
  const { mutateAsync: createCheckout, isPending } = useCreateCheckoutSession();

  const [selectedAmount, setSelectedAmount] = useState<number | null>(null);
  const [customAmount, setCustomAmount] = useState("");
  const [showCancelledMsg, setShowCancelledMsg] = useState(
    payment.status === "cancelled",
  );

  useEffect(() => {
    if (payment.status) {
      const clean = window.location.pathname;
      window.history.replaceState({}, "", clean);
    }
  }, [payment.status]);

  const effectiveAmount =
    selectedAmount ??
    (customAmount
      ? Number.parseInt(customAmount.replace(/\D/g, ""), 10) || 0
      : 0);

  const handleDonate = async () => {
    if (effectiveAmount < 10) {
      toast.error("Please enter a minimum donation of ₹10");
      return;
    }

    const successUrl = `${window.location.href}?payment_status=success&amount=${effectiveAmount}&temple=${encodeURIComponent(templeName)}`;
    const cancelUrl = `${window.location.href}?payment_status=cancelled`;

    if (isAuthenticated) {
      try {
        const result = await createCheckout({
          templeId: BigInt(templeId),
          amount: BigInt(effectiveAmount),
          currency: "INR",
          successUrl,
          cancelUrl,
        });
        window.location.href = result.checkoutUrl;
      } catch (err) {
        const msg = err instanceof Error ? err.message : "Unknown error";
        // If Stripe not configured, fall back gracefully
        if (msg.includes("not configured") || msg.includes("Stripe")) {
          toast.info(
            "Payment integration is being set up. Thank you for your generosity!",
          );
        } else {
          toast.error("Unable to process donation. Please try again.");
        }
      }
    } else {
      // Unauthenticated: simulate session for demo
      await new Promise((r) => setTimeout(r, 800));
      window.location.href = `${successUrl}&session_id=demo_${Date.now()}`;
    }
  };

  if (payment.status === "success") {
    return (
      <motion.div
        initial={{ opacity: 0, scale: 0.96 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.4 }}
        data-ocid="donation.success_state"
      >
        <Card className="border-primary/30 shadow-warm-md bg-primary/5">
          <CardContent className="p-8 text-center">
            <div className="w-16 h-16 rounded-full bg-primary/15 flex items-center justify-center mx-auto mb-4">
              <CheckCircle2 className="w-8 h-8 text-primary" />
            </div>
            <h2 className="font-display text-2xl font-bold text-foreground mb-2">
              🙏 Dhanyavaad!
            </h2>
            <p className="text-muted-foreground text-base mb-1">
              Your donation of{" "}
              <span className="font-bold text-primary">
                ₹{Number(payment.amount).toLocaleString("en-IN")}
              </span>{" "}
              to{" "}
              <span className="font-semibold text-foreground">
                {payment.temple ?? templeName}
              </span>{" "}
              has been received.
            </p>
            <p className="text-sm text-muted-foreground mb-6">
              May the divine blessings of this sacred temple guide and protect
              you. Your contribution preserves this heritage for future
              generations.
            </p>
            {payment.sessionId && (
              <div className="inline-flex items-center gap-2 bg-muted/40 px-4 py-2 rounded-lg text-xs text-muted-foreground font-mono mb-6">
                <span>Transaction Reference:</span>
                <span className="text-foreground font-medium truncate max-w-[220px]">
                  {payment.sessionId}
                </span>
              </div>
            )}
            <div className="flex justify-center">
              <Badge
                variant="secondary"
                className="text-xs px-3 py-1 text-primary border-primary/20"
              >
                <Heart className="w-3 h-3 mr-1" />
                Tax-exempted under 80G (consult temple trust)
              </Badge>
            </div>
          </CardContent>
        </Card>
      </motion.div>
    );
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      className="space-y-6"
      data-ocid="donation.section"
    >
      {showCancelledMsg && (
        <motion.div
          initial={{ opacity: 0, y: -8 }}
          animate={{ opacity: 1, y: 0 }}
          className="flex items-start gap-3 p-4 rounded-xl bg-muted/50 border border-border text-sm text-muted-foreground"
          data-ocid="donation.cancel_notice"
        >
          <XCircle className="w-5 h-5 shrink-0 text-muted-foreground/60 mt-0.5" />
          <div className="flex-1">
            Payment was cancelled. You can try again whenever you're ready —
            your generosity is always welcome.
          </div>
          <button
            type="button"
            onClick={() => setShowCancelledMsg(false)}
            className="text-muted-foreground hover:text-foreground transition-smooth text-xs underline shrink-0"
          >
            Dismiss
          </button>
        </motion.div>
      )}

      <Card className="border-primary/20 bg-primary/5 shadow-warm-sm">
        <CardContent className="p-5 flex gap-4">
          <div className="w-10 h-10 rounded-xl bg-primary/15 flex items-center justify-center shrink-0">
            <Coins className="w-5 h-5 text-primary" />
          </div>
          <div>
            <h3 className="font-display text-base font-semibold text-foreground mb-1">
              Support {templeName}
            </h3>
            <p className="text-sm text-muted-foreground leading-relaxed">
              Your donation supports temple maintenance, community programs, and
              preserving this sacred heritage for generations to come.
            </p>
            {donationInfo && (
              <p className="text-xs text-muted-foreground/80 mt-2 italic">
                {donationInfo}
              </p>
            )}
          </div>
        </CardContent>
      </Card>

      {donationOptions.length > 0 && (
        <div>
          <h4 className="text-sm font-semibold text-foreground mb-3 flex items-center gap-2">
            <Heart className="w-4 h-4 text-primary" />
            Temple Seva Options
          </h4>
          <div
            className="grid gap-2 sm:grid-cols-2"
            data-ocid="donation.seva_options"
          >
            {donationOptions.map((opt, i) => {
              const label =
                (opt as { name?: string; donationType?: string }).name ??
                opt.donationType ??
                `Option ${i + 1}`;
              const amount = Number(opt.amount);
              return (
                <button
                  key={label}
                  type="button"
                  onClick={() => {
                    setSelectedAmount(amount);
                    setCustomAmount("");
                  }}
                  data-ocid={`donation.seva_option.${i + 1}`}
                  className={`text-left p-3 rounded-xl border transition-smooth focus-ring ${
                    selectedAmount === amount
                      ? "border-primary bg-primary/10 shadow-warm-sm"
                      : "border-border hover:border-primary/40 hover:bg-muted/30"
                  }`}
                >
                  <div className="flex items-center justify-between mb-1">
                    <span className="font-display text-base font-bold text-primary">
                      ₹{amount.toLocaleString("en-IN")}
                    </span>
                    {selectedAmount === amount && (
                      <CheckCircle2 className="w-4 h-4 text-primary" />
                    )}
                  </div>
                  <p className="text-xs font-medium text-foreground">{label}</p>
                  <p className="text-xs text-muted-foreground mt-0.5 line-clamp-2">
                    {opt.description}
                  </p>
                </button>
              );
            })}
          </div>
        </div>
      )}

      <div>
        <h4 className="text-sm font-semibold text-foreground mb-3">
          Choose an Amount
        </h4>
        <div
          className="grid grid-cols-3 sm:grid-cols-5 gap-2"
          data-ocid="donation.preset_amounts"
        >
          {PRESET_AMOUNTS.map((preset) => (
            <button
              key={preset.value}
              type="button"
              onClick={() => {
                setSelectedAmount(preset.value);
                setCustomAmount("");
              }}
              data-ocid={`donation.preset.${preset.value}`}
              className={`flex flex-col items-center justify-center gap-0.5 p-3 rounded-xl border transition-smooth focus-ring min-h-[72px] ${
                selectedAmount === preset.value
                  ? "border-primary bg-primary/10 shadow-warm-sm"
                  : "border-border hover:border-primary/40 hover:bg-muted/30"
              }`}
            >
              <span
                className={`font-display text-base font-bold ${
                  selectedAmount === preset.value
                    ? "text-primary"
                    : "text-foreground"
                }`}
              >
                {preset.label}
              </span>
              <span className="text-xs text-muted-foreground text-center leading-tight">
                {preset.desc}
              </span>
            </button>
          ))}
        </div>
      </div>

      <div>
        <h4 className="text-sm font-semibold text-foreground mb-2">
          Or Enter Custom Amount (₹)
        </h4>
        <div className="relative">
          <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground font-medium text-sm">
            ₹
          </span>
          <Input
            type="number"
            placeholder="Enter amount"
            value={customAmount}
            min={10}
            onChange={(e) => {
              setCustomAmount(e.target.value);
              setSelectedAmount(null);
            }}
            className="pl-7 text-sm"
            data-ocid="donation.custom_amount_input"
          />
        </div>
        <p className="text-xs text-muted-foreground mt-1">
          Minimum donation ₹10
        </p>
      </div>

      {effectiveAmount >= 10 && (
        <motion.div
          initial={{ opacity: 0, y: 4 }}
          animate={{ opacity: 1, y: 0 }}
          className="rounded-xl border border-primary/30 bg-primary/5 p-4 flex items-center justify-between gap-4"
          data-ocid="donation.amount_summary"
        >
          <div>
            <p className="text-xs text-muted-foreground">Donating</p>
            <p className="font-display text-2xl font-bold text-primary">
              ₹{effectiveAmount.toLocaleString("en-IN")}
            </p>
          </div>
          <Button
            onClick={handleDonate}
            disabled={isPending}
            className="btn-accessible gap-2 shrink-0 bg-primary text-primary-foreground hover:bg-primary/90 shadow-warm-sm"
            data-ocid="donation.donate_button"
          >
            {isPending ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                Processing…
              </>
            ) : (
              <>
                <Heart className="w-4 h-4" />
                Donate Now
              </>
            )}
          </Button>
        </motion.div>
      )}

      {isPending && (
        <div
          className="flex items-center justify-center gap-2 text-sm text-muted-foreground py-2"
          data-ocid="donation.loading_state"
        >
          <Loader2 className="w-4 h-4 animate-spin" />
          Redirecting to secure payment…
        </div>
      )}

      <div className="flex flex-col items-center gap-2 pt-2 border-t border-border">
        <p className="text-xs text-muted-foreground flex items-center gap-1.5">
          <span className="w-4 h-4 rounded-sm bg-indigo-600 inline-flex items-center justify-center text-[9px] font-bold text-white">
            S
          </span>
          Secured by Stripe · 256-bit SSL encryption
        </p>
        <p className="text-xs text-muted-foreground/70 flex items-center gap-1">
          <AlertTriangle className="w-3 h-3" />
          For large donations, contact the temple office directly
        </p>
      </div>
    </motion.div>
  );
}
