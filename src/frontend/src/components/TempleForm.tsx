import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Textarea } from "@/components/ui/textarea";
import { PlusCircle, Trash2 } from "lucide-react";
import { useId, useState } from "react";
import type {
  ContactInfo,
  DarshanTiming,
  DonationOption,
  Festival,
  Pooja,
  Temple,
  TempleInput,
} from "../backend.d";

interface TempleFormProps {
  initial?: Temple;
  onSubmit: (data: TempleInput) => void;
  onCancel: () => void;
  isLoading?: boolean;
}

let _uid = 0;
function uid() {
  return ++_uid;
}

type Keyed<T> = T & { _key: number };

function keyed<T>(v: T): Keyed<T> {
  return { ...v, _key: uid() };
}

function emptyDarshan(): Keyed<DarshanTiming> {
  return keyed({ timingLabel: "", openTime: "", closeTime: "" });
}
function emptyPooja(): Keyed<Pooja> {
  return keyed({ name: "", time: "", description: "", isIncluded: false });
}
function emptyFestival(): Keyed<Festival> {
  return keyed({ name: "", date: "", significance: "" });
}
function emptyDonation(): Keyed<DonationOption> {
  return keyed({ donationType: "", description: "", amount: BigInt(0) });
}

export default function TempleForm({
  initial,
  onSubmit,
  onCancel,
  isLoading = false,
}: TempleFormProps) {
  const formId = useId();
  const [name, setName] = useState(initial?.name ?? "");
  const [deity, setDeity] = useState(initial?.deity ?? "");
  const [state, setState] = useState(initial?.state ?? "");
  const [city, setCity] = useState(initial?.city ?? "");
  const [district, setDistrict] = useState(initial?.district ?? "");
  const [address, setAddress] = useState(initial?.address ?? "");
  const [description, setDescription] = useState(initial?.description ?? "");
  const [history, setHistory] = useState(initial?.history ?? "");
  const [architectureStyle, setArchitectureStyle] = useState(
    initial?.architectureStyle ?? "",
  );
  const [nonHinduRestriction, setNonHinduRestriction] = useState(
    initial?.nonHinduRestriction ?? false,
  );
  const [avgVisit, setAvgVisit] = useState(
    initial?.averageVisitDuration ? String(initial.averageVisitDuration) : "60",
  );
  const [tags, setTags] = useState(initial?.tags.join(", ") ?? "");
  const [images, setImages] = useState(initial?.images.join(", ") ?? "");

  const [darshanTimings, setDarshanTimings] = useState<Keyed<DarshanTiming>[]>(
    initial?.darshanTimings.length
      ? initial.darshanTimings.map(keyed)
      : [emptyDarshan()],
  );
  const [poojas, setPoojas] = useState<Keyed<Pooja>[]>(
    initial?.poojaSchedule.length
      ? initial.poojaSchedule.map(keyed)
      : [emptyPooja()],
  );
  const [festivals, setFestivals] = useState<Keyed<Festival>[]>(
    initial?.festivalCalendar.length
      ? initial.festivalCalendar.map(keyed)
      : [emptyFestival()],
  );
  const [donations, setDonations] = useState<Keyed<DonationOption>[]>(
    initial?.donationOptions.length
      ? initial.donationOptions.map(keyed)
      : [emptyDonation()],
  );

  const [contactPhone, setContactPhone] = useState(
    initial?.contactInfo.phone ?? "",
  );
  const [contactEmail, setContactEmail] = useState(
    initial?.contactInfo.email ?? "",
  );
  const [contactWebsite, setContactWebsite] = useState(
    initial?.contactInfo.website ?? "",
  );

  function updateDarshan<K extends keyof DarshanTiming>(
    key2: number,
    field: K,
    val: DarshanTiming[K],
  ) {
    setDarshanTimings((prev) =>
      prev.map((d) => (d._key === key2 ? { ...d, [field]: val } : d)),
    );
  }
  function updatePooja<K extends keyof Pooja>(
    key2: number,
    field: K,
    val: Pooja[K],
  ) {
    setPoojas((prev) =>
      prev.map((p) => (p._key === key2 ? { ...p, [field]: val } : p)),
    );
  }
  function updateFestival<K extends keyof Festival>(
    key2: number,
    field: K,
    val: Festival[K],
  ) {
    setFestivals((prev) =>
      prev.map((f) => (f._key === key2 ? { ...f, [field]: val } : f)),
    );
  }
  function updateDonation<K extends keyof DonationOption>(
    key2: number,
    field: K,
    val: DonationOption[K],
  ) {
    setDonations((prev) =>
      prev.map((d) => (d._key === key2 ? { ...d, [field]: val } : d)),
    );
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const contactInfo: ContactInfo = {};
    if (contactPhone) contactInfo.phone = contactPhone;
    if (contactEmail) contactInfo.email = contactEmail;
    if (contactWebsite) contactInfo.website = contactWebsite;

    const input: TempleInput = {
      name,
      deity,
      state,
      city,
      district,
      address,
      description,
      history,
      architectureStyle,
      nonHinduRestriction,
      averageVisitDuration: BigInt(Number(avgVisit) || 60),
      tags: tags
        .split(",")
        .map((t) => t.trim())
        .filter(Boolean),
      images: images
        .split(",")
        .map((t) => t.trim())
        .filter(Boolean),
      darshanTimings: darshanTimings.map(({ _key: _k, ...rest }) => rest),
      poojaSchedule: poojas.map(({ _key: _k, ...rest }) => rest),
      festivalCalendar: festivals.map(({ _key: _k, ...rest }) => rest),
      donationOptions: donations.map(({ _key: _k, ...rest }) => ({
        ...rest,
        amount: BigInt(Number(rest.amount) || 0),
      })),
      specialDarshans: initial?.specialDarshans ?? [],
      contactInfo,
    };
    onSubmit(input);
  };

  const fieldCls = "flex flex-col gap-1.5";
  const sectionCls =
    "bg-muted/30 rounded-xl p-4 flex flex-col gap-4 border border-border";

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-6 text-sm">
      {/* Basic Info */}
      <div className={sectionCls}>
        <h3 className="font-display font-semibold text-base text-foreground">
          Basic Information
        </h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-name`}>Temple Name *</Label>
            <Input
              id={`${formId}-name`}
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
              placeholder="e.g. Brihadeeswarar Temple"
              data-ocid="tf-name"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-deity`}>Deity *</Label>
            <Input
              id={`${formId}-deity`}
              value={deity}
              onChange={(e) => setDeity(e.target.value)}
              required
              placeholder="e.g. Lord Shiva"
              data-ocid="tf-deity"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-state`}>State *</Label>
            <Input
              id={`${formId}-state`}
              value={state}
              onChange={(e) => setState(e.target.value)}
              required
              placeholder="e.g. Tamil Nadu"
              data-ocid="tf-state"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-city`}>City *</Label>
            <Input
              id={`${formId}-city`}
              value={city}
              onChange={(e) => setCity(e.target.value)}
              required
              placeholder="e.g. Thanjavur"
              data-ocid="tf-city"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-district`}>District</Label>
            <Input
              id={`${formId}-district`}
              value={district}
              onChange={(e) => setDistrict(e.target.value)}
              placeholder="e.g. Thanjavur"
              data-ocid="tf-district"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-arch`}>Architecture Style</Label>
            <Input
              id={`${formId}-arch`}
              value={architectureStyle}
              onChange={(e) => setArchitectureStyle(e.target.value)}
              placeholder="e.g. Dravidian"
              data-ocid="tf-arch"
            />
          </div>
          <div className={`${fieldCls} sm:col-span-2`}>
            <Label htmlFor={`${formId}-address`}>Address</Label>
            <Input
              id={`${formId}-address`}
              value={address}
              onChange={(e) => setAddress(e.target.value)}
              placeholder="Full address"
              data-ocid="tf-address"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-avg`}>Avg. Visit Duration (min)</Label>
            <Input
              id={`${formId}-avg`}
              type="number"
              min={0}
              value={avgVisit}
              onChange={(e) => setAvgVisit(e.target.value)}
              placeholder="60"
              data-ocid="tf-avg-visit"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-tags`}>Tags (comma-separated)</Label>
            <Input
              id={`${formId}-tags`}
              value={tags}
              onChange={(e) => setTags(e.target.value)}
              placeholder="Jyotirlinga, Shiva, Sacred"
              data-ocid="tf-tags"
            />
          </div>
          <div className={`${fieldCls} sm:col-span-2`}>
            <Label htmlFor={`${formId}-images`}>
              Image URLs (comma-separated)
            </Label>
            <Input
              id={`${formId}-images`}
              value={images}
              onChange={(e) => setImages(e.target.value)}
              placeholder="https://…"
              data-ocid="tf-images"
            />
          </div>
        </div>
        <div className="flex items-center gap-3 pt-1">
          <Switch
            id={`${formId}-nonhindu`}
            checked={nonHinduRestriction}
            onCheckedChange={setNonHinduRestriction}
            data-ocid="tf-nonhindu-toggle"
          />
          <Label htmlFor={`${formId}-nonhindu`} className="cursor-pointer">
            Non-Hindu Entry Restriction
          </Label>
        </div>
      </div>

      {/* Description & History */}
      <div className={sectionCls}>
        <h3 className="font-display font-semibold text-base text-foreground">
          Description &amp; History
        </h3>
        <div className={fieldCls}>
          <Label htmlFor={`${formId}-desc`}>Description</Label>
          <Textarea
            id={`${formId}-desc`}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            rows={3}
            placeholder="Brief description of the temple…"
            data-ocid="tf-description"
          />
        </div>
        <div className={fieldCls}>
          <Label htmlFor={`${formId}-history`}>History</Label>
          <Textarea
            id={`${formId}-history`}
            value={history}
            onChange={(e) => setHistory(e.target.value)}
            rows={4}
            placeholder="Historical background and significance…"
            data-ocid="tf-history"
          />
        </div>
      </div>

      {/* Darshan Timings */}
      <div className={sectionCls}>
        <div className="flex items-center justify-between">
          <h3 className="font-display font-semibold text-base text-foreground">
            Darshan Timings
          </h3>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            className="gap-1.5 text-primary"
            onClick={() => setDarshanTimings((p) => [...p, emptyDarshan()])}
            data-ocid="tf-add-darshan"
          >
            <PlusCircle className="w-4 h-4" /> Add Slot
          </Button>
        </div>
        {darshanTimings.map((d) => (
          <div
            key={d._key}
            className="grid grid-cols-2 sm:grid-cols-4 gap-3 items-end"
          >
            <div className={fieldCls}>
              <Label>Label</Label>
              <Input
                value={d.timingLabel}
                onChange={(e) =>
                  updateDarshan(d._key, "timingLabel", e.target.value)
                }
                placeholder="Morning"
              />
            </div>
            <div className={fieldCls}>
              <Label>Open Time</Label>
              <Input
                value={d.openTime}
                onChange={(e) =>
                  updateDarshan(d._key, "openTime", e.target.value)
                }
                placeholder="06:00 AM"
              />
            </div>
            <div className={fieldCls}>
              <Label>Close Time</Label>
              <Input
                value={d.closeTime}
                onChange={(e) =>
                  updateDarshan(d._key, "closeTime", e.target.value)
                }
                placeholder="12:30 PM"
              />
            </div>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="text-destructive hover:text-destructive h-9 self-end"
              onClick={() =>
                setDarshanTimings((p) => p.filter((x) => x._key !== d._key))
              }
              aria-label="Remove timing"
            >
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        ))}
      </div>

      {/* Pooja Schedule */}
      <div className={sectionCls}>
        <div className="flex items-center justify-between">
          <h3 className="font-display font-semibold text-base text-foreground">
            Pooja Schedule
          </h3>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            className="gap-1.5 text-primary"
            onClick={() => setPoojas((p) => [...p, emptyPooja()])}
            data-ocid="tf-add-pooja"
          >
            <PlusCircle className="w-4 h-4" /> Add Pooja
          </Button>
        </div>
        {poojas.map((p) => (
          <div
            key={p._key}
            className="grid grid-cols-2 sm:grid-cols-4 gap-3 items-end"
          >
            <div className={fieldCls}>
              <Label>Pooja Name</Label>
              <Input
                value={p.name}
                onChange={(e) => updatePooja(p._key, "name", e.target.value)}
                placeholder="Abhishekam"
              />
            </div>
            <div className={fieldCls}>
              <Label>Time</Label>
              <Input
                value={p.time}
                onChange={(e) => updatePooja(p._key, "time", e.target.value)}
                placeholder="07:00 AM"
              />
            </div>
            <div className={fieldCls}>
              <Label>Description</Label>
              <Input
                value={p.description}
                onChange={(e) =>
                  updatePooja(p._key, "description", e.target.value)
                }
                placeholder="Brief description"
              />
            </div>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="text-destructive hover:text-destructive h-9 self-end"
              onClick={() =>
                setPoojas((prev) => prev.filter((x) => x._key !== p._key))
              }
              aria-label="Remove pooja"
            >
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        ))}
      </div>

      {/* Festivals */}
      <div className={sectionCls}>
        <div className="flex items-center justify-between">
          <h3 className="font-display font-semibold text-base text-foreground">
            Festival Calendar
          </h3>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            className="gap-1.5 text-primary"
            onClick={() => setFestivals((p) => [...p, emptyFestival()])}
            data-ocid="tf-add-festival"
          >
            <PlusCircle className="w-4 h-4" /> Add Festival
          </Button>
        </div>
        {festivals.map((f) => (
          <div
            key={f._key}
            className="grid grid-cols-2 sm:grid-cols-4 gap-3 items-end"
          >
            <div className={fieldCls}>
              <Label>Festival Name</Label>
              <Input
                value={f.name}
                onChange={(e) => updateFestival(f._key, "name", e.target.value)}
                placeholder="Mahashivaratri"
              />
            </div>
            <div className={fieldCls}>
              <Label>Date / Period</Label>
              <Input
                value={f.date}
                onChange={(e) => updateFestival(f._key, "date", e.target.value)}
                placeholder="Feb/Mar"
              />
            </div>
            <div className={fieldCls}>
              <Label>Significance</Label>
              <Input
                value={f.significance}
                onChange={(e) =>
                  updateFestival(f._key, "significance", e.target.value)
                }
                placeholder="Brief significance"
              />
            </div>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="text-destructive hover:text-destructive h-9 self-end"
              onClick={() =>
                setFestivals((prev) => prev.filter((x) => x._key !== f._key))
              }
              aria-label="Remove festival"
            >
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        ))}
      </div>

      {/* Donation Options */}
      <div className={sectionCls}>
        <div className="flex items-center justify-between">
          <h3 className="font-display font-semibold text-base text-foreground">
            Donation Options
          </h3>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            className="gap-1.5 text-primary"
            onClick={() => setDonations((p) => [...p, emptyDonation()])}
            data-ocid="tf-add-donation"
          >
            <PlusCircle className="w-4 h-4" /> Add Option
          </Button>
        </div>
        {donations.map((d) => (
          <div
            key={d._key}
            className="grid grid-cols-2 sm:grid-cols-4 gap-3 items-end"
          >
            <div className={fieldCls}>
              <Label>Type</Label>
              <Input
                value={d.donationType}
                onChange={(e) =>
                  updateDonation(d._key, "donationType", e.target.value)
                }
                placeholder="Hundi"
              />
            </div>
            <div className={fieldCls}>
              <Label>Amount (₹)</Label>
              <Input
                type="number"
                min={0}
                value={String(d.amount)}
                onChange={(e) =>
                  updateDonation(
                    d._key,
                    "amount",
                    BigInt(Number(e.target.value) || 0),
                  )
                }
                placeholder="500"
              />
            </div>
            <div className={fieldCls}>
              <Label>Description</Label>
              <Input
                value={d.description}
                onChange={(e) =>
                  updateDonation(d._key, "description", e.target.value)
                }
                placeholder="Brief description"
              />
            </div>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="text-destructive hover:text-destructive h-9 self-end"
              onClick={() =>
                setDonations((prev) => prev.filter((x) => x._key !== d._key))
              }
              aria-label="Remove donation"
            >
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        ))}
      </div>

      {/* Contact Info */}
      <div className={sectionCls}>
        <h3 className="font-display font-semibold text-base text-foreground">
          Contact Information
        </h3>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-phone`}>Phone</Label>
            <Input
              id={`${formId}-phone`}
              value={contactPhone}
              onChange={(e) => setContactPhone(e.target.value)}
              placeholder="+91 XXXXX XXXXX"
              data-ocid="tf-phone"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-cemail`}>Email</Label>
            <Input
              id={`${formId}-cemail`}
              type="email"
              value={contactEmail}
              onChange={(e) => setContactEmail(e.target.value)}
              placeholder="temple@example.com"
              data-ocid="tf-contact-email"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor={`${formId}-website`}>Website</Label>
            <Input
              id={`${formId}-website`}
              value={contactWebsite}
              onChange={(e) => setContactWebsite(e.target.value)}
              placeholder="https://…"
              data-ocid="tf-website"
            />
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="flex justify-end gap-3 pt-2">
        <Button
          type="button"
          variant="outline"
          onClick={onCancel}
          className="btn-accessible"
          data-ocid="tf-cancel"
        >
          Cancel
        </Button>
        <Button
          type="submit"
          disabled={isLoading}
          className="btn-accessible bg-primary text-primary-foreground hover:bg-primary/90"
          data-ocid="tf-submit"
        >
          {isLoading ? "Saving…" : initial ? "Update Temple" : "Add Temple"}
        </Button>
      </div>
    </form>
  );
}
