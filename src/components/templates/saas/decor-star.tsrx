import type { OctaneNode } from "octane"
import type { Octane } from "octane/jsx-runtime"

import Star14 from "@/components/stars/s14.tsrx"

import { cn, type ClassValue } from "@/lib/utils"

type StarComponent = (
  props: Octane.SVGProps<SVGSVGElement> & {
    color?: string
    stroke?: string
    strokeWidth?: number
    pathClassName?: string
  },
) => OctaneNode

// Faint 56px grid used as the background of every white section.
export const GRID_BACKGROUND =
  "bg-[linear-gradient(to_right,#80808033_1px,transparent_1px),linear-gradient(to_bottom,#80808033_1px,transparent_1px)] bg-size-[56px_56px]"

// Non-scaling stroke keeps every star outline at 2px, matching card borders.
// Avoid chart-1 for decoration: it reads as the interactive main colour.
export default function DecorStar({
  star: Star,
  color = "var(--chart-3)",
  spin = false,
  strokeWidth = 2,
  class: klass,
  style,
}: {
  star: StarComponent
  color?: string
  spin?: boolean
  strokeWidth?: number
  class?: ClassValue
  style?: Octane.SVGProps<SVGSVGElement>["style"]
}) @{
  <Star
    aria-hidden
    color={color}
    stroke="var(--border)"
    strokeWidth={strokeWidth}
    pathClassName="[vector-effect:non-scaling-stroke]"
    class={cn(
      "pointer-events-none shrink-0 overflow-visible",
      spin && "animate-[spin_40s_linear_infinite] motion-reduce:animate-none",
      klass,
    )}
    style={style}
  />
}

// A pair of big background stars for a section. The section needs
// `relative isolate overflow-hidden`: isolate makes it a stacking context, so
// the -z-10 stars paint above its background but below all of its content.
export function SectionStars({
  stars,
}: {
  stars: { star: StarComponent; color: string; class: string }[]
}) @{
  <>
    @for (const item of stars; index i; key i) {
      <DecorStar
        star={item.star}
        color={item.color}
        class={cn("absolute -z-10", item.class)}
      />
    }
  </>
}

export function StarSticker({
  star = Star14,
  color = "var(--chart-3)",
  children,
  class: klass,
}: {
  star?: StarComponent
  color?: string
  children: OctaneNode
  class?: ClassValue
}) @{
  <div
    class={cn(
      "group absolute z-10 flex size-24 rotate-6 items-center justify-center text-center font-heading leading-tight text-foreground",
      klass,
    )}
  >
    <DecorStar
      star={star}
      color={color}
      class="absolute inset-0 size-full transition-transform duration-700 ease-out group-hover:rotate-45 motion-reduce:transition-none"
    />
    <span class="relative">{children}</span>
  </div>
}
