import {
  ChartNoAxesColumn,
  ChevronsUpDown,
  LayoutDashboard,
  Megaphone,
  Package,
  ShoppingCart,
  Store,
  Users,
} from "@octanejs/lucide"

import { Avatar, AvatarFallback } from "@/components/ui/avatar.tsrx"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu.tsrx"
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuBadge,
  SidebarMenuButton,
  SidebarMenuItem,
  useSidebar,
} from "@/components/ui/sidebar.tsrx"

import { ORDERS, PRODUCTS, USER } from "./data"

const GROUPS = [
  {
    label: "Analytics",
    items: [
      { id: "overview", title: "Overview", icon: LayoutDashboard },
      { id: "revenue", title: "Revenue", icon: ChartNoAxesColumn },
      { id: "marketing", title: "Marketing", icon: Megaphone },
    ],
  },
  {
    label: "Store",
    items: [
      {
        id: "orders",
        title: "Orders",
        icon: ShoppingCart,
        badge: ORDERS.filter((order) => order.status === "Processing").length,
      },
      { id: "customers", title: "Customers", icon: Users },
      {
        id: "inventory",
        title: "Inventory",
        icon: Package,
        badge: PRODUCTS.filter((item) => item.stock < item.reorder).length,
      },
    ],
  },
]

export default function AppSidebar({ active }: { active: string }) @{
  const { setOpenMobile } = useSidebar()

  // The 15px side padding centres 32px icons in the collapsed sidebar, so
  // they stay put while it opens and closes.
  <Sidebar collapsible="icon">
    <SidebarHeader class="h-16 justify-center px-3.75">
      <a
        href="#overview"
        onClick={() => setOpenMobile(false)}
        class="flex items-center gap-3 overflow-hidden font-heading text-xl"
      >
        <span class="flex size-8 shrink-0 items-center justify-center rounded-base border-2 border-border bg-main text-main-foreground">
          <Store class="size-4" />
        </span>
        <span>Tally</span>
      </a>
    </SidebarHeader>

    <SidebarContent class="overflow-x-hidden">
      @for (const group of GROUPS; key group.label) {
        <SidebarGroup class="px-3.75">
          <SidebarGroupLabel>{group.label as string}</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu class="gap-1.5">
              @for (const item of group.items; key item.id) {
                const Icon = item.icon

                <SidebarMenuItem>
                  <SidebarMenuButton
                    isActive={item.id === active}
                    tooltip={item.title}
                    render={
                      <a
                        href={`#${item.id}`}
                        aria-current={item.id === active ? "page" : undefined}
                        onClick={() => setOpenMobile(false)}
                      />
                    }
                  >
                    <Icon />
                    <span>{item.title as string}</span>
                  </SidebarMenuButton>
                  @if ("badge" in item) {
                    <SidebarMenuBadge>{String(item.badge)}</SidebarMenuBadge>
                  }
                </SidebarMenuItem>
              }
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      }
    </SidebarContent>

    <SidebarFooter class="px-3.75">
      <SidebarMenu>
        <SidebarMenuItem>
          <DropdownMenu>
            <DropdownMenuTrigger render={<SidebarMenuButton size="lg" />}>
              <Avatar size="sm" class="shrink-0 -outline-offset-2">
                <AvatarFallback class="bg-chart-3">
                  {USER.initials as string}
                </AvatarFallback>
              </Avatar>
              <span class="grid min-w-0 flex-1 leading-tight">
                <span class="truncate font-heading">{USER.name as string}</span>
                <span class="truncate text-xs">{USER.email as string}</span>
              </span>
              <ChevronsUpDown class="ml-auto" />
            </DropdownMenuTrigger>
            <DropdownMenuContent side="top" align="start" class="w-52">
              <DropdownMenuGroup>
                <DropdownMenuLabel>My account</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem
                  render={<a href="#profile" />}
                  onClick={() => setOpenMobile(false)}
                >
                  Profile
                </DropdownMenuItem>
                <DropdownMenuItem
                  render={<a href="#billing" />}
                  onClick={() => setOpenMobile(false)}
                >
                  Billing
                </DropdownMenuItem>
                <DropdownMenuItem>Log out</DropdownMenuItem>
              </DropdownMenuGroup>
            </DropdownMenuContent>
          </DropdownMenu>
        </SidebarMenuItem>
      </SidebarMenu>
    </SidebarFooter>
  </Sidebar>
}
