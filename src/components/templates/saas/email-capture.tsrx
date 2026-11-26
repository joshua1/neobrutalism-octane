import { Check } from "@octanejs/lucide"
import { useId, useState } from "octane"

import { Button } from "@/components/ui/button.tsrx"
import { Input } from "@/components/ui/input.tsrx"
import { cn, type ClassValue } from "@/lib/utils"

export default function EmailCapture({
  cta = "Get started",
  variant = "default",
  class: klass,
}: {
  cta?: string
  variant?: "default" | "neutral"
  class?: ClassValue
}) @{
  const id = useId()
  const [submitted, setSubmitted] = useState(false)

  @if (submitted) {
    <p
      role="status"
      class={cn(
        "flex h-11 w-fit items-center gap-2 rounded-base border-2 border-border bg-chart-4 px-4 text-sm font-heading text-foreground shadow-shadow",
        klass,
      )}
    >
      <Check class="size-4" /> You&apos;re on the list. Check your inbox.
    </p>
  } @else {
    <form
      onSubmit={(e: SubmitEvent) => {
        e.preventDefault()
        setSubmitted(true)
      }}
      class={cn("flex w-full max-w-md flex-col gap-3 sm:flex-row", klass)}
    >
      <label for={id} class="sr-only">
        Work email
      </label>
      <Input
        id={id}
        type="email"
        required
        placeholder="Work email"
        class="h-11"
      />
      <Button type="submit" size="lg" variant={variant} class="shrink-0">
        {cta as string}
      </Button>
    </form>
  }
}
