import { Check, CreditCard, Download } from "@octanejs/lucide"

import { useState } from "octane"

import { Badge } from "@/components/ui/badge.tsrx"
import { Button } from "@/components/ui/button.tsrx"
import { Progress, ProgressLabel } from "@/components/ui/progress.tsrx"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table.tsrx"

import {
  CARD,
  downloadCsv,
  formatMoney,
  formatNumber,
  getPeriod,
  INVOICES,
  NEXT_INVOICE,
  ordersOf,
  PLANS,
  PRODUCTS,
  SEATS_USED,
  total,
  USER,
} from "./data"
import { ChartCard } from "./shared.tsrx"

const ORDERS_USED = total(getPeriod(28).days, ordersOf)

export default function Billing() @{
  const [planName, setPlanName] = useState("Growth")
  const plan = PLANS.find((item) => item.name === planName) ?? PLANS[0]
  const usage = [
    { label: "Orders, last 4 weeks", used: ORDERS_USED, limit: plan.orders },
    { label: "Products", used: PRODUCTS.length, limit: plan.products },
    { label: "Team seats", used: SEATS_USED, limit: plan.seats },
  ]

  <>
    <div class="grid gap-5 lg:grid-cols-3">
      @for (const item of PLANS; key item.name) {
        const current = item.name === plan.name
        const features = [
          `${formatNumber(item.orders)} orders per month`,
          `${formatNumber(item.products)} products`,
          `${item.seats} team seats`,
        ]

        <ChartCard
          title={item.name}
          description={item.description}
          action={current && <Badge class="bg-chart-3">Current</Badge>}
        >
          <p class="text-sm">
            <span class="font-heading text-3xl tabular-nums">
              {formatMoney(item.price) as string}
            </span>{" "}
            per month
          </p>
          <ul class="my-5 flex flex-1 flex-col gap-2 text-sm">
            @for (const feature of features; key feature) {
              <li class="flex items-center gap-2">
                <Check class="size-4 shrink-0" />
                {feature as string}
              </li>
            }
          </ul>
          <Button
            variant={current ? "neutral" : "default"}
            class="disabled:opacity-100 disabled:shadow-none data-disabled:opacity-100 data-disabled:shadow-none"
            disabled={current}
            onClick={() => setPlanName(item.name)}
          >
            {(current ? "Your plan" : `Switch to ${item.name}`) as string}
          </Button>
        </ChartCard>
      }
    </div>

    <div class="grid gap-5 xl:grid-cols-3">
      <ChartCard
        title="Usage"
        description={`Against your ${plan.name} limits`}
        class="xl:col-span-2"
      >
        <div class="flex flex-col gap-5">
          @for (const item of usage; key item.label) {
            <Progress
              value={Math.min(100, (item.used / item.limit) * 100)}
              class={
                item.used > item.limit * 0.9
                  ? "**:data-[slot=progress-indicator]:bg-chart-2"
                  : "**:data-[slot=progress-indicator]:bg-chart-4"
              }
            >
              <ProgressLabel>{item.label as string}</ProgressLabel>
              <span class="ml-auto text-sm tabular-nums">
                {`${formatNumber(item.used)} of ${formatNumber(item.limit)}`}
              </span>
            </Progress>
          }
        </div>
      </ChartCard>
      <ChartCard title="Payment method" description="Charged every month">
        <div class="flex min-h-36 flex-1 flex-col justify-between rounded-base border-2 border-border bg-chart-3 p-4">
          <div class="flex items-center justify-between gap-4">
            <span class="font-heading">{USER.store as string}</span>
            <CreditCard class="size-6 shrink-0" />
          </div>
          <p class="font-heading text-lg tracking-wider whitespace-nowrap tabular-nums">
            <span aria-hidden>{"**** **** **** "}</span>
            <span class="sr-only">{"Card ending in "}</span>
            {CARD.last4 as string}
          </p>
          <div class="flex items-center justify-between gap-4 text-sm">
            <span>{USER.name as string}</span>
            <span class="tabular-nums">{`Expires ${CARD.expires}`}</span>
          </div>
        </div>
        <p
          class="mt-4 flex items-center justify-between gap-4 text-sm"
          aria-live="polite"
        >
          <span>{`Next invoice on ${NEXT_INVOICE}`}</span>
          <span class="font-heading tabular-nums">
            {formatMoney(plan.price) as string}
          </span>
        </p>
      </ChartCard>
    </div>

    <ChartCard title="Invoices" description="Your past payments">
      <Table class="max-sm:[&_td]:px-2 max-sm:[&_th]:px-2">
        <TableHeader>
          <TableRow>
            <TableHead>Invoice</TableHead>
            <TableHead>Date</TableHead>
            <TableHead class="hidden sm:table-cell">Plan</TableHead>
            <TableHead class="hidden sm:table-cell">Status</TableHead>
            <TableHead class="text-right">Total</TableHead>
            <TableHead class="w-12 sm:w-16">
              <span class="sr-only">Download</span>
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          @for (const invoice of INVOICES; key invoice.id) {
            <TableRow class="bg-secondary-background">
              <TableCell class="py-3 font-heading whitespace-nowrap">
                {invoice.id as string}
              </TableCell>
              <TableCell class="py-3 whitespace-nowrap">
                {invoice.date as string}
              </TableCell>
              <TableCell class="hidden py-3 sm:table-cell">
                {invoice.plan as string}
              </TableCell>
              <TableCell class="hidden py-3 sm:table-cell">
                <Badge class="bg-chart-4">Paid</Badge>
              </TableCell>
              <TableCell class="py-3 text-right font-heading tabular-nums">
                {formatMoney(invoice.total) as string}
              </TableCell>
              <TableCell class="py-3">
                <Button
                  size="icon-xs"
                  variant="noShadow"
                  aria-label={`Download ${invoice.id}`}
                  onClick={() =>
                    downloadCsv(`${invoice.id}.csv`, [
                      ["invoice", "date", "plan", "total"],
                      [
                        invoice.id,
                        `"${invoice.date}"`,
                        invoice.plan,
                        invoice.total,
                      ],
                    ])
                  }
                >
                  <Download />
                </Button>
              </TableCell>
            </TableRow>
          }
        </TableBody>
      </Table>
    </ChartCard>
  </>
}
