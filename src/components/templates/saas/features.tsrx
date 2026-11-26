import {
  CreditCard,
  GitBranch,
  KeyRound,
  Mail,
  MessageSquare,
  ScrollText,
  ShieldCheck,
  Sparkles,
  Webhook,
  Zap,
} from "@octanejs/lucide"
import type { OctaneNode } from "octane"

import Star19 from "@/components/stars/s19.tsrx"
import Star25 from "@/components/stars/s25.tsrx"
import Star35 from "@/components/stars/s35.tsrx"
import { Avatar, AvatarFallback } from "@/components/ui/avatar.tsrx"
import { Kbd, KbdGroup } from "@/components/ui/kbd.tsrx"

import { cn, type ClassValue } from "@/lib/utils"

import DecorStar, { SectionStars } from "./decor-star.tsrx"
import SectionHeading from "./section-heading.tsrx"

const ISSUES = [
  {
    title: "Checkout fails on Safari 17",
    label: "Bug · P1",
    priority: "bg-chart-2",
    owner: "SC",
  },
  {
    title: "Add CSV export to reports",
    label: "Feature",
    priority: "bg-chart-3",
    owner: "JM",
  },
  {
    title: "Duplicate of PLN-88",
    label: "Duplicate",
    priority: "bg-secondary-background",
    owner: "AR",
  },
  {
    title: "Webhook retries time out",
    label: "Bug · P2",
    priority: "bg-chart-3",
    owner: "TB",
  },
]

const TRIAGE_STATS = [
  { value: "24", label: "triaged today" },
  { value: "6", label: "duplicates closed" },
  { value: "0", label: "left in inbox" },
]

const SHORTCUTS = [
  { keys: ["⌘", "K"], label: "Command menu" },
  { keys: ["C"], label: "Create issue" },
  { keys: ["G", "I"], label: "Go to inbox" },
]

const INTEGRATIONS = [
  { name: "GitHub", icon: GitBranch, color: "bg-chart-5" },
  { name: "Slack", icon: MessageSquare, color: "bg-chart-4" },
  { name: "Stripe", icon: CreditCard, color: "bg-chart-1" },
  { name: "Email", icon: Mail, color: "bg-chart-3" },
  { name: "Zapier", icon: Zap, color: "bg-chart-2" },
  { name: "Webhooks", icon: Webhook, color: "bg-chart-4" },
]

const SECURITY = [
  { label: "SOC 2 Type II", icon: ShieldCheck },
  { label: "SAML SSO & SCIM", icon: KeyRound },
  { label: "Audit logs", icon: ScrollText },
]

const BARS = [62, 48, 70, 41, 55, 36, 44, 30, 38, 26]

function Cell({
  title,
  description,
  class: klass,
  decoration,
  children,
}: {
  title: string
  description: string
  class?: ClassValue
  decoration?: OctaneNode
  children: OctaneNode
}) @{
  <div
    class={cn(
      "relative flex flex-col overflow-hidden rounded-base border-2 border-border bg-secondary-background shadow-shadow",
      klass,
    )}
  >
    {decoration}
    <div class="relative p-6 pb-0">
      <h3 class="font-heading text-xl">{title as string}</h3>
      <p class="mt-2 text-sm font-base">{description as string}</p>
    </div>
    <div class="relative flex flex-1 items-end p-6">{children}</div>
  </div>
}

export default function Features() @{
  <section
    id="features"
    class="relative isolate scroll-mt-16 overflow-hidden border-b-4 border-border bg-background px-5 py-24"
  >
    <SectionStars
      stars={[
        {
          star: Star35,
          color: "var(--chart-2)",
          class: "-left-16 top-[62%] size-24 rotate-[10deg] lg:size-40",
        },
        {
          star: Star19,
          color: "var(--chart-3)",
          class:
            "-right-16 lg:-right-10 top-10 size-24 -rotate-[25deg] lg:size-40",
        },
      ]}
    />
    <div class="mx-auto w-full max-w-6xl">
      <SectionHeading
        eyebrow="Features"
        title={<>Everything your team needs. Nothing it doesn&apos;t.</>}
        description="From triage to release, Planly covers the whole loop."
      />

      <div class="grid gap-5 md:grid-cols-6">
        <Cell
          title="AI triage that actually helps"
          description="Agents label, prioritise, dedupe and assign every incoming issue, so your inbox stays at zero."
          class="md:col-span-6 lg:col-span-4 lg:row-span-2"
          decoration={
            <DecorStar
              star={Star25}
              color="var(--chart-5)"
              class="absolute -right-12 -top-12 hidden size-40 rotate-12 sm:block lg:hidden xl:block"
            />
          }
        >
          <div class="w-full space-y-3">
            <div class="mb-6 grid grid-cols-1 gap-3 sm:grid-cols-3">
              @for (const stat of TRIAGE_STATS; key stat.label) {
                <div class="rounded-base border-2 border-border bg-chart-3 p-2 shadow-shadow min-[375px]:p-3">
                  <p class="font-heading text-2xl sm:text-3xl">
                    {stat.value as string}
                  </p>
                  <p class="hyphens-auto text-xs font-base wrap-anywhere">
                    {stat.label as string}
                  </p>
                </div>
              }
            </div>
            @for (const issue of ISSUES; key issue.title) {
              <div class="flex items-center gap-3 rounded-base border-2 border-border bg-background p-3">
                <span
                  class={cn(
                    "size-3 shrink-0 rounded-full border-2 border-border",
                    issue.priority,
                  )}
                />
                <p class="flex-1 truncate text-sm font-heading">
                  {issue.title as string}
                </p>
                <span class="hidden items-center gap-1 rounded-base border-2 border-border bg-chart-3 px-1.5 text-[11px] font-heading sm:inline-flex">
                  <Sparkles class="size-3" />
                  {issue.label as string}
                </span>
                <Avatar size="sm" class="size-7">
                  <AvatarFallback class="text-[10px] font-heading">
                    {issue.owner as string}
                  </AvatarFallback>
                </Avatar>
              </div>
            }
          </div>
        </Cell>

        <Cell
          title="Keyboard first"
          description="Every action is one shortcut away."
          class="md:col-span-3 lg:col-span-2"
        >
          <div class="w-full space-y-2.5">
            @for (const shortcut of SHORTCUTS; key shortcut.label) {
              <div class="flex items-center justify-between rounded-base border-2 border-border bg-background px-3 py-2 text-sm font-base">
                {shortcut.label as string}
                <KbdGroup>
                  @for (const keyName of shortcut.keys; key keyName) {
                    <Kbd>{keyName as string}</Kbd>
                  }
                </KbdGroup>
              </div>
            }
          </div>
        </Cell>

        <Cell
          title="Cycle analytics"
          description="See where work gets stuck before it slips."
          class="md:col-span-3 lg:col-span-2"
        >
          <div class="w-full">
            <p class="font-heading text-4xl">−32%</p>
            <p class="text-xs font-base">median cycle time, last 10 sprints</p>
            <div class="mt-4 flex h-20 items-end gap-1.5">
              @for (const height of BARS; index i; key i) {
                <div
                  class={cn(
                    "flex-1 rounded-t-sm border-2 border-border",
                    i === BARS.length - 1 ? "bg-chart-4" : "bg-chart-1",
                  )}
                  style={{ height: `${height}%` }}
                />
              }
            </div>
          </div>
        </Cell>

        <Cell
          title="Plays well with your stack"
          description="Two-way sync with the tools you already use, plus an open API."
          class="md:col-span-3"
        >
          <div class="grid w-full grid-cols-1 gap-3 min-[360px]:grid-cols-2 sm:grid-cols-3 md:grid-cols-2 lg:grid-cols-3">
            @for (const { name, icon: Icon, color } of INTEGRATIONS; key name) {
              <div class="flex items-center gap-2 rounded-base border-2 border-border bg-background p-2.5 text-sm font-heading">
                <span
                  class={cn(
                    "flex size-7 shrink-0 items-center justify-center rounded-base border-2 border-border",
                    color,
                  )}
                >
                  <Icon class="size-4" />
                </span>
                {name as string}
              </div>
            }
          </div>
        </Cell>

        <Cell
          title="Enterprise-grade security"
          description="Your data is encrypted at rest and in transit, with controls your security team will love."
          class="bg-chart-3 md:col-span-3"
        >
          <div class="flex w-full flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <ul class="space-y-2">
              @for (const { label, icon: Icon } of SECURITY; key label) {
                <li class="flex items-center gap-2 text-sm font-heading">
                  <Icon class="size-4" /> {label as string}
                </li>
              }
            </ul>
            <div class="rounded-base border-2 border-border bg-secondary-background px-4 py-3 shadow-shadow">
              <p class="font-heading text-3xl">99.99%</p>
              <p class="text-xs font-base">uptime SLA</p>
            </div>
          </div>
        </Cell>
      </div>
    </div>
  </section>
}
