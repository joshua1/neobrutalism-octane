import { Avatar, AvatarFallback } from "@/components/ui/avatar.tsrx"
import type { ChartConfig } from "@/components/ui/chart.tsrx"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table.tsrx"

import { Columns, Donut, StackedArea } from "./charts.tsrx"
import {
  COHORTS,
  formatMoney,
  formatNumber,
  formatPercent,
  ordersOf,
  revenueOf,
  SEGMENTS,
  split,
  TOP_CUSTOMERS,
  total,
  type Day,
  type Period,
} from "./data"
import { ChartCard, Heatmap, StatCard, StatGrid } from "./shared.tsrx"

const MIX_CONFIG = {
  returning: { label: "Returning", color: "var(--chart-1)" },
  first: { label: "New", color: "var(--chart-3)" },
} satisfies ChartConfig

const SIZE_CONFIG = {
  size: { label: "New customers", color: "var(--chart-5)" },
} satisfies ChartConfig

const newIn = (days: Day[]) => total(days, (day) => day.newCustomers)
const returningIn = (days: Day[]) => total(days, (day) => day.returning)
const repeatIn = (days: Day[]) =>
  (returningIn(days) / total(days, ordersOf)) * 100
const perNewIn = (days: Day[]) => total(days, revenueOf) / newIn(days)

export default function Customers({ period }: { period: Period }) @{
  const { days, previous, buckets, unit } = period
  const segments = split(
    total(days, ordersOf),
    SEGMENTS.map((segment) => segment.share),
  )
  const stat = (measure: (days: Day[]) => number) => ({
    compare: { current: measure(days), previous: measure(previous) },
    trend: buckets.map((item) => measure(item.days)),
  })

  <>
    <StatGrid>
      <StatCard
        label="New customers"
        value={formatNumber(newIn(days))}
        color="var(--chart-3)"
        {...stat(newIn)}
      />
      <StatCard
        label="Returning orders"
        value={formatNumber(returningIn(days))}
        {...stat(returningIn)}
      />
      <StatCard
        label="Repeat rate"
        value={formatPercent(repeatIn(days))}
        color="var(--chart-4)"
        {...stat(repeatIn)}
      />
      <StatCard
        label="Revenue per new"
        value={formatMoney(perNewIn(days))}
        color="var(--chart-5)"
        {...stat(perNewIn)}
      />
    </StatGrid>

    <div class="grid gap-5 xl:grid-cols-3">
      <ChartCard
        title="New and returning"
        description={`Orders per ${unit}`}
        class="xl:col-span-2"
      >
        <StackedArea
          config={MIX_CONFIG}
          class="h-80"
          data={buckets.map((item) => ({
            label: item.label,
            returning: returningIn(item.days),
            first: newIn(item.days),
          }))}
        />
      </ChartCard>
      <ChartCard title="Segments" description="Orders by customer type">
        <Donut
          caption="orders"
          data={SEGMENTS.map(({ key, label, color }, i) => ({
            key,
            label,
            color,
            value: segments[i],
          }))}
        />
      </ChartCard>
    </div>

    <div class="grid gap-5 xl:grid-cols-3">
      <ChartCard
        title="Retention"
        description="Customers who ordered again, by month of first order"
        class="xl:col-span-2"
      >
        <Heatmap
          corner="Cohort"
          columns={COHORTS.map((_, i) => `Month ${i}`)}
          rows={COHORTS.map((cohort) => ({
            label: cohort.month,
            values: cohort.retention,
          }))}
          max={100}
          suffix="%"
        />
      </ChartCard>
      <ChartCard title="Cohort size" description="First orders per month">
        <Columns
          config={SIZE_CONFIG}
          data={COHORTS.map((cohort) => ({
            label: cohort.month,
            size: cohort.size,
          }))}
        />
      </ChartCard>
    </div>

    <ChartCard title="Top customers" description="By lifetime spend">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Customer</TableHead>
            <TableHead class="hidden sm:table-cell">Country</TableHead>
            <TableHead class="text-right">Orders</TableHead>
            <TableHead class="text-right">Spent</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          @for (const customer of TOP_CUSTOMERS; key customer.name) {
            <TableRow class="bg-secondary-background">
              <TableCell class="py-3">
                <div class="flex items-center gap-3">
                  <Avatar size="sm">
                    <AvatarFallback class="bg-chart-3">
                      {
                        customer.name
                          .split(" ")
                          .map((part) => part[0])
                          .join("") as string
                      }
                    </AvatarFallback>
                  </Avatar>
                  {customer.name as string}
                </div>
              </TableCell>
              <TableCell class="hidden py-3 sm:table-cell">
                {customer.country as string}
              </TableCell>
              <TableCell class="py-3 text-right tabular-nums">
                {String(customer.orders)}
              </TableCell>
              <TableCell class="py-3 text-right font-heading tabular-nums">
                {formatMoney(customer.spent) as string}
              </TableCell>
            </TableRow>
          }
        </TableBody>
      </Table>
    </ChartCard>
  </>
}
