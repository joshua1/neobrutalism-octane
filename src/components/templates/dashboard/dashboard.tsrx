import { Download } from "@octanejs/lucide"

import { useEffect, useMemo, useState, type ComponentType } from "octane"

import { Button } from "@/components/ui/button.tsrx"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select.tsrx"
import {
  SidebarInset,
  SidebarProvider,
  SidebarTrigger,
} from "@/components/ui/sidebar.tsrx"

import AppSidebar from "./app-sidebar.tsrx"
import Billing from "./billing.tsrx"
import Customers from "./customers.tsrx"
import {
  downloadCsv,
  getPeriod,
  ordersOf,
  RANGES,
  revenueOf,
  sessionsOf,
  type Period,
} from "./data"
import Inventory from "./inventory.tsrx"
import Marketing from "./marketing.tsrx"
import Orders from "./orders.tsrx"
import Overview from "./overview.tsrx"
import Profile from "./profile.tsrx"
import Revenue from "./revenue.tsrx"

const PAGES: Record<
  string,
  {
    title: string
    component: ComponentType<{ period: Period }>
    // Account pages have no date range or export.
    account?: boolean
  }
> = {
  overview: { title: "Overview", component: Overview },
  revenue: { title: "Revenue", component: Revenue },
  marketing: { title: "Marketing", component: Marketing },
  orders: { title: "Orders", component: Orders },
  customers: { title: "Customers", component: Customers },
  inventory: { title: "Inventory", component: Inventory },
  profile: { title: "Profile", component: Profile, account: true },
  billing: { title: "Billing", component: Billing, account: true },
}

// The open page lives in the URL hash, so the back button and shared links
// work while everything stays on one route.
function useHashPage() {
  const [page, setPage] = useState("overview")

  useEffect(() => {
    const read = () => {
      const hash = window.location.hash.slice(1)
      setPage(Object.hasOwn(PAGES, hash) ? hash : "overview")
      window.scrollTo({ top: 0, behavior: "instant" })
    }
    read()
    window.addEventListener("hashchange", read)
    return () => window.removeEventListener("hashchange", read)
  }, [])

  return page
}

function exportCsv(period: Period) {
  downloadCsv("tally-report.csv", [
    ["date", "revenue", "orders", "refunds", "new_customers", "sessions"],
    ...period.days.map((day) => [
      day.date.toISOString().slice(0, 10),
      revenueOf(day),
      ordersOf(day),
      day.refunds,
      day.newCustomers,
      sessionsOf(day),
    ]),
  ])
}

export default function Dashboard() @{
  const page = useHashPage()
  const [range, setRange] = useState("28")
  const period = useMemo(() => getPeriod(Number(range)), [range])
  const { title, component: Page, account } = PAGES[page]

  <SidebarProvider
    class="font-base text-foreground"
    // Collapsed, the sidebar is as wide as the header is tall (h-16).
    style={{ "--sidebar-width-icon": "4rem" }}
  >
    <AppSidebar active={page} />
    <SidebarInset class="min-w-0 bg-background">
      <header class="sticky top-0 z-10 flex h-16 shrink-0 items-center gap-2 border-b-2 border-border bg-secondary-background px-4 sm:gap-3 sm:px-6">
        <SidebarTrigger class="size-9 shrink-0" />
        <h1 class="truncate font-heading text-lg sm:text-xl">
          {title as string}
        </h1>
        @if (!account) {
          <div class="ml-auto flex items-center gap-2 sm:gap-3">
            <Select
              items={RANGES}
              value={range}
              onValueChange={(value: string | null) => setRange(value ?? "28")}
            >
              <SelectTrigger
                aria-label="Date range"
                class="h-9 w-37 bg-secondary-background"
              >
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  @for (const item of RANGES; key item.value) {
                    <SelectItem value={item.value}>
                      {item.label as string}
                    </SelectItem>
                  }
                </SelectGroup>
              </SelectContent>
            </Select>
            <Button
              size="sm"
              variant="noShadow"
              aria-label="Export CSV"
              onClick={() => exportCsv(period)}
            >
              <span class="hidden sm:inline">Export</span>
              <Download />
            </Button>
          </div>
        }
      </header>
      <div class="flex flex-col gap-5 p-4 pb-28 sm:p-6 sm:pb-28">
        <Page period={period} />
      </div>
    </SidebarInset>
  </SidebarProvider>
}
