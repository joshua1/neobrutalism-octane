import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table.tsrx"

import { formatDate, formatMoney, type Order } from "./data"
import { StatusBadge } from "./shared.tsrx"

export function OrderTable({ orders }: { orders: Order[] }) @{
  <Table>
    <TableHeader>
      <TableRow>
        <TableHead>Order</TableHead>
        <TableHead>Customer</TableHead>
        <TableHead class="hidden md:table-cell">Product</TableHead>
        <TableHead class="hidden sm:table-cell">Date</TableHead>
        <TableHead>Status</TableHead>
        <TableHead class="text-right">Total</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      @for (const order of orders; key order.id) {
        <TableRow class="bg-secondary-background">
          <TableCell class="py-3 font-heading">{order.id as string}</TableCell>
          <TableCell class="py-3 whitespace-nowrap">
            {order.customer as string}
          </TableCell>
          <TableCell class="hidden py-3 whitespace-nowrap md:table-cell">
            {order.product as string}
          </TableCell>
          <TableCell class="hidden py-3 whitespace-nowrap sm:table-cell">
            {formatDate(order.date) as string}
          </TableCell>
          <TableCell class="py-3">
            <StatusBadge status={order.status} />
          </TableCell>
          <TableCell class="py-3 text-right font-heading tabular-nums">
            {formatMoney(order.total) as string}
          </TableCell>
        </TableRow>
      }
    </TableBody>
  </Table>
}
