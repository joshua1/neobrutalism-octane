import { createFileRoute } from "@octanejs/tanstack-router"

import TemplateToolbar from "@/components/app/template-toolbar.tsrx"
import SaasLanding, {
  metadata,
} from "@/components/templates/saas/saas-landing.tsrx"

export const Route = createFileRoute("/templates/saas")({
  head: () => ({
    meta: [
      { title: metadata.title },
      { name: "description", content: metadata.description },
    ],
  }),
  component: Page,
})

function Page() @{
  <>
    <SaasLanding />
    <TemplateToolbar />
  </>
}
