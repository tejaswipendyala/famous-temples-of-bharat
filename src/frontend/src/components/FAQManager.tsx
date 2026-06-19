import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { Textarea } from "@/components/ui/textarea";
import { useActor } from "@caffeineai/core-infrastructure";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { HelpCircle, Pencil, PlusCircle, Trash2 } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";
import { createActor } from "../backend";
import type { Faq, FaqInput, backendInterface } from "../backend.d";

interface FAQManagerProps {
  templeId: bigint;
  templeName: string;
}

interface FAQFormState {
  question: string;
  answer: string;
}

export default function FAQManager({ templeId, templeName }: FAQManagerProps) {
  const { actor: rawActor, isFetching: actorLoading } = useActor(createActor);
  const actor = rawActor as backendInterface | null;
  const qc = useQueryClient();

  const { data: faqs = [], isLoading } = useQuery<Faq[]>({
    queryKey: ["faqs", templeId.toString()],
    queryFn: async () => {
      if (!actor) return [];
      return actor.getFAQs(templeId);
    },
    enabled: !!actor && !actorLoading,
  });

  const [editingId, setEditingId] = useState<bigint | null>(null);
  const [showAdd, setShowAdd] = useState(false);
  const [form, setForm] = useState<FAQFormState>({ question: "", answer: "" });

  const invalidate = () =>
    qc.invalidateQueries({ queryKey: ["faqs", templeId.toString()] });

  const addMutation = useMutation({
    mutationFn: async (input: FaqInput) => {
      if (!actor) throw new Error("No actor");
      return actor.addFAQ(input);
    },
    onSuccess: () => {
      toast.success("FAQ added successfully");
      setShowAdd(false);
      setForm({ question: "", answer: "" });
      invalidate();
    },
    onError: () => toast.error("Failed to add FAQ"),
  });

  const updateMutation = useMutation({
    mutationFn: async ({
      id,
      input,
    }: {
      id: bigint;
      input: FaqInput;
    }) => {
      if (!actor) throw new Error("No actor");
      return actor.updateFAQ(id, input);
    },
    onSuccess: () => {
      toast.success("FAQ updated");
      setEditingId(null);
      setForm({ question: "", answer: "" });
      invalidate();
    },
    onError: () => toast.error("Failed to update FAQ"),
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: bigint) => {
      if (!actor) throw new Error("No actor");
      return actor.deleteFAQ(id);
    },
    onSuccess: () => {
      toast.success("FAQ deleted");
      invalidate();
    },
    onError: () => toast.error("Failed to delete FAQ"),
  });

  const startEdit = (faq: Faq) => {
    setEditingId(faq.id);
    setForm({ question: faq.question, answer: faq.answer });
    setShowAdd(false);
  };

  const startAdd = () => {
    setShowAdd(true);
    setEditingId(null);
    setForm({ question: "", answer: "" });
  };

  const cancelForm = () => {
    setShowAdd(false);
    setEditingId(null);
    setForm({ question: "", answer: "" });
  };

  const handleSubmitAdd = (e: React.FormEvent) => {
    e.preventDefault();
    addMutation.mutate({
      question: form.question,
      answer: form.answer,
      templeId,
    });
  };

  const handleSubmitEdit = (e: React.FormEvent) => {
    e.preventDefault();
    if (editingId === null) return;
    updateMutation.mutate({
      id: editingId,
      input: { question: form.question, answer: form.answer, templeId },
    });
  };

  const fieldCls = "flex flex-col gap-1.5";

  return (
    <div className="flex flex-col gap-4" data-ocid="faq-manager">
      <div className="flex items-center justify-between">
        <p className="text-sm text-muted-foreground">
          Managing FAQs for{" "}
          <span className="font-medium text-foreground">{templeName}</span>
        </p>
        <Button
          type="button"
          size="sm"
          className="gap-1.5 bg-primary text-primary-foreground hover:bg-primary/90"
          onClick={startAdd}
          data-ocid="faq-add-btn"
        >
          <PlusCircle className="w-4 h-4" /> Add FAQ
        </Button>
      </div>

      {/* Add / Edit Form */}
      {(showAdd || editingId !== null) && (
        <form
          onSubmit={showAdd ? handleSubmitAdd : handleSubmitEdit}
          className="bg-muted/30 border border-border rounded-xl p-4 flex flex-col gap-4"
          data-ocid="faq-form"
        >
          <h4 className="font-display font-semibold text-sm text-foreground">
            {showAdd ? "New FAQ" : "Edit FAQ"}
          </h4>
          <div className={fieldCls}>
            <Label htmlFor="faq-question">Question *</Label>
            <Input
              id="faq-question"
              value={form.question}
              onChange={(e) =>
                setForm((f) => ({ ...f, question: e.target.value }))
              }
              required
              placeholder="What are the darshan timings?"
              data-ocid="faq-question-input"
            />
          </div>
          <div className={fieldCls}>
            <Label htmlFor="faq-answer">Answer *</Label>
            <Textarea
              id="faq-answer"
              value={form.answer}
              onChange={(e) =>
                setForm((f) => ({ ...f, answer: e.target.value }))
              }
              required
              rows={3}
              placeholder="The darshan timings are…"
              data-ocid="faq-answer-input"
            />
          </div>
          <div className="flex justify-end gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={cancelForm}
              data-ocid="faq-form-cancel"
            >
              Cancel
            </Button>
            <Button
              type="submit"
              size="sm"
              disabled={addMutation.isPending || updateMutation.isPending}
              className="bg-primary text-primary-foreground hover:bg-primary/90"
              data-ocid="faq-form-submit"
            >
              {addMutation.isPending || updateMutation.isPending
                ? "Saving…"
                : showAdd
                  ? "Add FAQ"
                  : "Update FAQ"}
            </Button>
          </div>
        </form>
      )}

      {/* FAQ List */}
      {isLoading ? (
        <div className="flex flex-col gap-3">
          {[1, 2, 3].map((n) => (
            <Skeleton key={n} className="h-16 w-full rounded-xl" />
          ))}
        </div>
      ) : faqs.length === 0 ? (
        <div
          className="flex flex-col items-center gap-3 py-12 text-center"
          data-ocid="faq-empty"
        >
          <HelpCircle className="w-10 h-10 text-muted-foreground/40" />
          <p className="text-muted-foreground text-sm">
            No FAQs yet for this temple.
          </p>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={startAdd}
            className="gap-1.5"
          >
            <PlusCircle className="w-4 h-4" /> Add the first FAQ
          </Button>
        </div>
      ) : (
        <div className="flex flex-col gap-3" data-ocid="faq-list">
          {faqs.map((faq) => (
            <div
              key={String(faq.id)}
              className="bg-card border border-border rounded-xl p-4 flex gap-4 items-start"
              data-ocid={`faq-row-${faq.id}`}
            >
              <HelpCircle className="w-5 h-5 text-primary shrink-0 mt-0.5" />
              <div className="flex-1 min-w-0">
                <p className="font-medium text-foreground text-sm leading-snug truncate">
                  {faq.question}
                </p>
                <p className="text-muted-foreground text-xs mt-1 line-clamp-2">
                  {faq.answer}
                </p>
              </div>
              <div className="flex gap-1 shrink-0">
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  className="h-8 w-8 p-0 text-muted-foreground hover:text-foreground"
                  onClick={() => startEdit(faq)}
                  aria-label={`Edit FAQ: ${faq.question}`}
                  data-ocid={`faq-edit-${faq.id}`}
                >
                  <Pencil className="w-3.5 h-3.5" />
                </Button>
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  className="h-8 w-8 p-0 text-destructive hover:text-destructive"
                  onClick={() => deleteMutation.mutate(faq.id)}
                  disabled={deleteMutation.isPending}
                  aria-label={`Delete FAQ: ${faq.question}`}
                  data-ocid={`faq-delete-${faq.id}`}
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </Button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
