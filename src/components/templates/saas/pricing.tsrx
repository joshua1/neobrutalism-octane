import { Check } from "@octanejs/lucide"
import { useState } from "octane"

import Star6 from "@/components/stars/s6.tsrx"
import Star15 from "@/components/stars/s15.tsrx"
import Star16 from "@/components/stars/s16.tsrx"
import { Badge } from "@/components/ui/badge.tsrx"
import { Button } from "@/components/ui/button.tsrx"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card.tsrx"
import { Switch } from "@/components/ui/switch.tsrx"

import { cn } from "@/lib/utils"

import { GRID_BACKGROUND, SectionStars, StarSticker } from "./decor-star.tsrx"
import SectionHeading from "./section-heading.tsrx"

const PLANS = [
  {
    name: "Starter",
    description: "For small teams getting organised.",
    monthly: 0,
    yearly: 0,
    cta: "Start for free",
    features: [
      "Up to 10 members",
      "Unlimited issues",
      "2 active cycles",
      "GitHub & Slack integrations",
    ],
  },
  {
    name: "Pro",
    description: "For growing teams that ship every week.",
    monthly: 12,
    yearly: 10,
    cta: "Start 14-day trial",
    popular: true,
    features: [
      "Unlimited members",
      "AI triage agents",
      "Roadmaps & cycle analytics",
      "Automations (100 rules)",
      "Priority support",
    ],
  },
  {
    name: "Business",
    description: "For companies with security and scale needs.",
    monthly: 24,
    yearly: 19,
    cta: "Contact sales",
    features: [
      "Everything in Pro",
      "SAML SSO & SCIM",
      "Audit logs & data residency",
      "Unlimited automations",
      "Dedicated success manager",
    ],
  },
]

export default function Pricing() @{
  const [yearly, setYearly] = useState(true)

  <section
    id="pricing"
    class={cn(
      "relative isolate scroll-mt-16 overflow-hidden border-b-4 border-border bg-secondary-background px-5 py-24",
      GRID_BACKGROUND,
    )}
  >
    <SectionStars
      stars={[
        {
          star: Star15,
          color: "var(--chart-5)",
          class:
            "-left-16 lg:-left-10 bottom-8 size-24 -rotate-[15deg] lg:size-40",
        },
        {
          star: Star6,
          color: "var(--chart-4)",
          class: "-right-16 top-[35%] size-24 rotate-[22deg] lg:size-40",
        },
      ]}
    />
    <div class="mx-auto w-full max-w-6xl">
      <SectionHeading
        eyebrow="Pricing"
        title="Pricing that scales with you"
        description="Start free. Upgrade when your team does."
        class="mb-8"
      />

      <div class="mb-14 flex justify-center">
        <div class="inline-flex items-center gap-3 rounded-base border-2 border-border bg-background px-4 py-2 text-sm shadow-shadow">
          <span class={yearly ? "font-base" : "font-heading"}>Monthly</span>
          <Switch
            checked={yearly}
            onCheckedChange={(checked: boolean) => setYearly(checked)}
            aria-label="Bill yearly"
          />
          <span class={yearly ? "font-heading" : "font-base"}>Yearly</span>
          <Badge class="bg-chart-4 font-heading">Save 20%</Badge>
        </div>
      </div>

      <div class="grid items-start gap-6 md:grid-cols-3 md:gap-4 lg:gap-6">
        @for (const plan of PLANS; key plan.name) {
          const price = yearly ? plan.yearly : plan.monthly
          const billing =
            price === 0
              ? "Free forever"
              : yearly
                ? `$${price * 12} billed yearly`
                : "Billed monthly"

          <Card class="relative">
            @if (plan.popular) {
              <StarSticker
                star={Star16}
                color="var(--chart-4)"
                class="-right-4 -top-10 text-xs"
              >
                Most
                <br />
                popular
              </StarSticker>
            }

            <CardHeader>
              <CardTitle class="text-2xl">{plan.name as string}</CardTitle>
              <CardDescription>{plan.description as string}</CardDescription>
              <div class="mt-4 flex items-baseline gap-1">
                <span class="font-heading text-5xl">{`$${price}`}</span>
                <span class="text-sm font-base">/user/mo</span>
              </div>
              <p class="text-xs font-base">{billing as string}</p>
            </CardHeader>

            <CardFooter>
              <Button
                class="w-full"
                variant={plan.popular ? "default" : "neutral"}
              >
                {plan.cta as string}
              </Button>
            </CardFooter>

            <CardContent class="border-t-2 border-border pt-6">
              <ul class="space-y-3">
                @for (const feature of plan.features; key feature) {
                  <li class="flex items-center gap-2.5 text-sm font-base">
                    <span
                      class={cn(
                        "flex size-5 shrink-0 items-center justify-center rounded-base border-2 border-border",
                        plan.popular ? "bg-chart-3" : "bg-secondary-background",
                      )}
                    >
                      <Check class="size-3" />
                    </span>
                    {feature as string}
                  </li>
                }
              </ul>
            </CardContent>
          </Card>
        }
      </div>
    </div>
  </section>
}
