import type { OctaneNode } from "octane"

import { cn, type ClassValue } from "@/lib/utils"

// Stroke is painted under the fill, so only half of it shows as an outline.
export function Eyebrow({
  children,
  class: klass,
}: {
  children: OctaneNode
  class?: ClassValue
}) @{
  <p
    class={cn(
      "text-lg font-heading uppercase tracking-[0.12em] text-chart-3 [paint-order:stroke_fill] [-webkit-text-stroke:2.5px_var(--border)]",
      klass,
    )}
  >
    {children}
  </p>
}

export default function SectionHeading({
  eyebrow,
  title,
  description,
  align = "center",
  class: klass,
}: {
  eyebrow: string
  title: OctaneNode
  description?: OctaneNode
  align?: "center" | "left"
  class?: ClassValue
}) @{
  <div
    class={cn(
      "mb-14 flex max-w-2xl flex-col gap-4",
      align === "center" ? "mx-auto items-center text-center" : "items-start",
      klass,
    )}
  >
    <Eyebrow>{eyebrow as string}</Eyebrow>
    <h2 class="text-balance font-heading text-4xl leading-tight sm:text-5xl">
      {title}
    </h2>
    @if (description) {
      <p class="text-lg font-base">{description}</p>
    }
  </div>
}
