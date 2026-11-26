import { Badge } from "@/components/ui/badge.tsrx"
import type { ChartConfig } from "@/components/ui/chart.tsrx"
import { Progress } from "@/components/ui/progress.tsrx"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table.tsrx"

import { Columns, Donut, RankedBars } from "./charts.tsrx"
import {
  formatMoney,
  formatNumber,
  PRODUCTS,
  revenueOf,
  sum,
  total,
  type Period,
} from "./data"
import { ChartCard, StatCard, StatGrid } from "./shared.tsrx"

const STOCK_CONFIG = {
  stock: { label: "In stock", color: "var(--chart-1)" },
  reorder: { label: "Reorder point", color: "var(--chart-3)" },
} satisfies ChartConfig

const CATEGORY_COLORS: Record<string, string> = {
  Bags: "var(--chart-1)",
  Apparel: "var(--chart-3)",
  Stationery: "var(--chart-2)",
  Home: "var(--chart-4)",
}

export default function Inventory({ period }: { period: Period }) @{
  const { days } = period
  const perDay = total(days, revenueOf) / days.length
  const rows = PRODUCTS.map((product) => {
    const soldPerDay = (perDay * product.share) / product.price
    return {
      ...product,
      value: product.stock * product.price,
      sold: Math.round(soldPerDay * days.length),
      cover: product.stock / soldPerDay,
      low: product.stock < product.reorder,
    }
  })
  const low = rows.filter((row) => row.low).length
  const byCover = [...rows].sort((a, b) => a.cover - b.cover)

  <>
    <StatGrid>
      <StatCard
        label="Stock value"
        value={formatMoney(sum(rows.map((row) => row.value)))}
      />
      <StatCard
        label="Units on hand"
        value={formatNumber(sum(rows.map((row) => row.stock)))}
      />
      <StatCard
        label="Units sold"
        value={formatNumber(sum(rows.map((row) => row.sold)))}
      />
      <StatCard
        label="Below reorder point"
        value={`${low} of ${rows.length}`}
      />
    </StatGrid>

    <div class="grid gap-5 xl:grid-cols-3">
      <ChartCard
        title="Stock levels"
        description="Units on hand against the reorder point"
        class="xl:col-span-2"
      >
        <Columns
          allLabels
          config={STOCK_CONFIG}
          class="h-80"
          data={rows.map(({ name, stock, reorder }) => ({
            label: name,
            stock,
            reorder,
          }))}
        />
      </ChartCard>
      <ChartCard title="Stock value" description="By category">
        <Donut
          caption="on hand"
          format={formatMoney}
          data={Object.entries(CATEGORY_COLORS).map(([category, color]) => ({
            key: category,
            label: category,
            color,
            value: sum(
              rows
                .filter((row) => row.category === category)
                .map((row) => row.value),
            ),
          }))}
        />
      </ChartCard>
    </div>

    <div class="grid gap-5 xl:grid-cols-3">
      <ChartCard title="Units sold" description="In this period">
        <RankedBars
          label="Units"
          color="var(--chart-5)"
          class="h-96"
          data={[...rows]
            .sort((a, b) => b.sold - a.sold)
            .map((row) => ({ label: row.name, value: row.sold }))}
        />
      </ChartCard>
      <ChartCard
        title="Days of cover"
        description="How long stock lasts at the current pace"
        class="xl:col-span-2"
      >
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Product</TableHead>
              <TableHead class="hidden w-1/3 md:table-cell">Stock</TableHead>
              <TableHead class="text-right">Days</TableHead>
              <TableHead>Status</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            @for (const row of byCover; key row.name) {
              <TableRow class="bg-secondary-background">
                <TableCell class="py-2.5 font-heading">
                  {row.name as string}
                </TableCell>
                <TableCell class="hidden py-2.5 md:table-cell">
                  <Progress
                    aria-label={`${row.name} stock against twice its reorder point`}
                    value={Math.min(100, (row.stock / (row.reorder * 2)) * 100)}
                    class={
                      row.low
                        ? "**:data-[slot=progress-indicator]:bg-chart-2"
                        : "**:data-[slot=progress-indicator]:bg-chart-4"
                    }
                  />
                </TableCell>
                <TableCell class="py-2.5 text-right tabular-nums">
                  {row.cover.toFixed(1) as string}
                </TableCell>
                <TableCell class="py-2.5">
                  <Badge class={row.low ? "bg-chart-2" : "bg-chart-4"}>
                    {(row.low ? "Reorder" : "Healthy") as string}
                  </Badge>
                </TableCell>
              </TableRow>
            }
          </TableBody>
        </Table>
      </ChartCard>
    </div>
  </>
}
