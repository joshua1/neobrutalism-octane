import { createFileRoute } from "@octanejs/tanstack-router"

import TemplateToolbar from "@/components/app/template-toolbar.tsrx"
import Dashboard from "@/components/templates/dashboard/dashboard.tsrx"

export const Route = createFileRoute("/templates/dashboard")({
  head: () => ({
    meta: [
      { title: "Tally - Store dashboard" },
      {
        name: "description",
        content:
          "Revenue, orders, customers, marketing and inventory at a glance.",
      },
    ],
  }),
  component: Page,
})

function Page() @{
  <>
    <Dashboard />
    <TemplateToolbar />
  </>
}
