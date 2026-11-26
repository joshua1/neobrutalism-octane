import { ArrowDownRight, ArrowUpRight } from "@octanejs/lucide"
import { Area, AreaChart, YAxis } from "@octanejs/recharts"

import type { OctaneNode } from "octane"

import { Badge } from "@/components/ui/badge.tsrx"
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card.tsrx"
import type { ChartConfig } from "@/components/ui/chart.tsrx"

import { cn } from "@/lib/utils"

import { ANIMATION, Chart } from "./charts.tsrx"
import { STATUS_COLORS, type Status } from "./data"

const SPARK_CONFIG = { value: { label: "Value" } } satisfies ChartConfig

// Change against the previous period. `invert` is for figures where lower is
// better, such as refunds.
function Delta({
  current,
  previous,
  invert = false,
}: {
  current: number
  previous: number
  invert?: boolean
}) @{
  const change = previous === 0 ? 0 : ((current - previous) / previous) * 100
  const up = change >= 0

  <Badge class={up !== invert ? "bg-chart-4" : "bg-chart-2"}>
    @if (up) {
      <ArrowUpRight />
    } @else {
      <ArrowDownRight />
    }
    {`${up ? "+" : "−"}${Math.abs(change).toFixed(1)}%`}
  </Badge>
}

export function StatGrid({ children }: { children: OctaneNode }) @{
  <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 xl:grid-cols-4">
    {children}
  </div>
}

// `compare` adds the change badge and `trend` the sparkline.
export function StatCard({
  label,
  value,
  compare,
  invert,
  trend,
  color = "var(--chart-1)",
}: {
  label: string
  value: string
  compare?: { current: number; previous: number }
  invert?: boolean
  trend?: number[]
  color?: string
}) @{
  <Card size="sm" class="min-w-0 bg-secondary-background">
    <CardContent class="flex flex-col gap-2">
      <div class="flex min-h-6 items-center justify-between gap-2">
        <p class="text-sm">{label as string}</p>
        @if (compare) {
          <Delta {...compare} invert={invert} />
        }
      </div>
      <div class="flex items-end justify-between gap-4">
        <p class="font-heading text-3xl tabular-nums">{value as string}</p>
        @if (trend) {
          <Chart
            aria-hidden
            config={SPARK_CONFIG}
            class="pointer-events-none aspect-auto h-10 w-20 shrink-0"
          >
            <AreaChart
              data={trend.map((item) => ({ value: item }))}
              margin={{ top: 2, right: 2, bottom: 2, left: 2 }}
              accessibilityLayer={false}
            >
              <YAxis hide domain={["dataMin", "dataMax"]} />
              <Area dataKey="value" type="linear" fill={color} {...ANIMATION} />
            </AreaChart>
          </Chart>
        }
      </div>
    </CardContent>
  </Card>
}

export function ChartCard({
  title,
  description,
  action,
  class: klass,
  children,
}: {
  title: string
  description?: string
  action?: OctaneNode
  class?: string
  children: OctaneNode
}) @{
  <Card class={cn("min-w-0 bg-secondary-background", klass)}>
    <CardHeader>
      <CardTitle>{title as string}</CardTitle>
      @if (description) {
        <CardDescription>{description as string}</CardDescription>
      }
      @if (action) {
        <CardAction>{action}</CardAction>
      }
    </CardHeader>
    <CardContent class="flex min-w-0 flex-1 flex-col justify-center">
      {children}
    </CardContent>
  </Card>
}

export function StatusBadge({ status }: { status: Status }) @{
  <Badge style={{ background: STATUS_COLORS[status] }}>
    {status as string}
  </Badge>
}

// Grid of values shaded on a single-hue scale. Missing cells stay blank.
export function Heatmap({
  corner,
  columns,
  rows,
  max,
  suffix = "",
}: {
  corner: string
  columns: string[]
  rows: { label: string; values: number[] }[]
  max: number
  suffix?: string
}) @{
  <div class="overflow-x-auto">
    <table class="w-full min-w-120 border-separate border-spacing-1 text-center text-xs tabular-nums">
      <thead>
        <tr>
          <th scope="col" class="pb-1 text-left font-base">
            {corner as string}
          </th>
          @for (const column of columns; key column) {
            <th scope="col" class="pb-1 font-base">
              {column as string}
            </th>
          }
        </tr>
      </thead>
      <tbody>
        @for (const row of rows; key row.label) {
          <tr>
            <th scope="row" class="pr-2 text-left font-heading">
              {row.label as string}
            </th>
            @for (const column of columns; index i; key column) {
              const value = row.values[i]

              @if (value === undefined) {
                <td />
              } @else {
                <td
                  title={`${row.label}, ${column}: ${value}${suffix}`}
                  class="h-9 rounded-base border-2 border-border"
                  style={{
                    background: `color-mix(in oklab, var(--chart-4) ${Math.round((value / max) * 100)}%, var(--secondary-background))`,
                  }}
                >
                  {`${value}${suffix}`}
                </td>
              }
            }
          </tr>
        }
      </tbody>
    </table>
  </div>
}
