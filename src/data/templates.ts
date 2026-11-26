// Imported rather than served from /public, so they get hashed file names the
// browser can cache for good.
import dashboardPreview from "@/assets/previews/dashboard.webp"
import saasPreview from "@/assets/previews/saas.webp"

export type Template = {
  name: string
  description: string
  href: string
  image: string
  registryItem: string
  // What to import once the registry item is installed, to render the
  // template from one of your routes.
  importPath: string
  component: string
}

const TEMPLATES: Template[] = [
  {
    name: "SaaS Landing Page",
    description:
      "A complete SaaS landing page with a product-board hero, bento features, tabbed product views, pricing toggle, testimonial marquee and more. Built entirely with neobrutalism components.",
    href: "/templates/saas",
    image: saasPreview,
    registryItem: "/r/saas-landing.json",
    importPath: "@/components/templates/saas/saas-landing.tsrx",
    component: "SaasLanding",
  },
  {
    name: "Dashboard",
    description:
      "A store analytics dashboard with a collapsible sidebar and six pages: overview, revenue, marketing, orders, customers and inventory. Date ranges, charts, heatmaps and searchable tables, all built with neobrutalism components.",
    href: "/templates/dashboard",
    image: dashboardPreview,
    registryItem: "/r/dashboard.json",
    importPath: "@/components/templates/dashboard/dashboard.tsrx",
    component: "Dashboard",
  },
]

export const PREVIEW_WIDTH = 1440
export const PREVIEW_HEIGHT = 900

export function getTemplate(href: string) {
  return TEMPLATES.find((template) => template.href === href)
}

export default TEMPLATES
