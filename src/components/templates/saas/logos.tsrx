import Star5 from "@/components/stars/s5.tsrx"
import Star6 from "@/components/stars/s6.tsrx"
import Star19 from "@/components/stars/s19.tsrx"
import Star22 from "@/components/stars/s22.tsrx"
import Star24 from "@/components/stars/s24.tsrx"
import Star25 from "@/components/stars/s25.tsrx"
import Star27 from "@/components/stars/s27.tsrx"
import Star28 from "@/components/stars/s28.tsrx"

import { cn } from "@/lib/utils"

import DecorStar from "./decor-star.tsrx"

const LOGOS = [
  { name: "Acme", icon: Star25, color: "var(--chart-1)" },
  { name: "Globex", icon: Star5, color: "var(--chart-3)" },
  { name: "Initech", icon: Star6, color: "var(--chart-2)" },
  { name: "Umbrella", icon: Star22, color: "var(--chart-4)" },
  { name: "Hooli", icon: Star19, color: "var(--chart-1)" },
  { name: "Soylent", icon: Star27, color: "var(--chart-3)" },
  { name: "Cyberdyne", icon: Star24, color: "var(--chart-2)" },
  { name: "Pied Piper", icon: Star28, color: "var(--chart-4)" },
]

function Track({ class: klass, hidden }: { class: string; hidden?: boolean }) @{
  <div
    aria-hidden={hidden}
    class={cn("flex shrink-0 items-center motion-reduce:animate-none", klass)}
    style={{ animationDuration: "35s" }}
  >
    @for (const { name, icon, color } of LOGOS; key name) {
      <div class="mx-8 flex shrink-0 items-center gap-6 whitespace-nowrap font-heading text-3xl">
        <DecorStar star={icon} color={color} class="size-9" />
        {name as string}
      </div>
    }
  </div>
}

export default function Logos() @{
  <section class="border-b-4 border-border bg-secondary-background py-8">
    <div class="relative flex overflow-hidden">
      <Track class="animate-marquee" />
      <Track class="absolute left-0 top-0 animate-marquee2" hidden />
    </div>
  </section>
}
