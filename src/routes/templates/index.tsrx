import { Download, Eye } from "@octanejs/lucide"
import { createFileRoute, Link } from "@octanejs/tanstack-router"

import TEMPLATES, {
  PREVIEW_HEIGHT,
  PREVIEW_WIDTH,
  type Template,
} from "@/data/templates"

import {
  PageDescription,
  PageHeader,
  PageHeading,
  PageWrapper,
} from "@/components/app/page.tsrx"
import { useStyling } from "@/components/app/styling-customizer.tsrx"
import TemplateInstallContent from "@/components/app/template-install-content.tsrx"
import { Button } from "@/components/ui/button.tsrx"
import { Dialog, DialogTrigger } from "@/components/ui/dialog.tsrx"

export const Route = createFileRoute("/templates/")({
  head: () => ({
    meta: [
      { title: "Templates - Neobrutalism components" },
      {
        name: "description",
        content:
          "Neobrutalism templates you can install with a single shadcn command.",
      },
    ],
  }),
  component: Page,
})

function InstallTemplateBtn({ template }: { template: Template }) @{
  const styling = useStyling()

  <Dialog>
    <DialogTrigger render={<Button class="w-full" />}>
      Install
      <Download />
    </DialogTrigger>
    <TemplateInstallContent template={template} styling={styling} />
  </Dialog>
}

function Page() @{
  <PageWrapper>
    <PageHeader>
      <PageHeading>Templates</PageHeading>
      <PageDescription>
        Full page templates built with neobrutalism components.
      </PageDescription>
    </PageHeader>

    <div class="grid gap-8 lg:grid-cols-2">
      @for (const template of TEMPLATES; key template.name) {
        <div class="min-w-0 overflow-hidden rounded-base border-2 border-border bg-secondary-background shadow-shadow">
          {/* preview */}
          <div class="relative border-b-2 border-border">
            <img
              src={template.image}
              alt={`${template.name} preview`}
              width={PREVIEW_WIDTH}
              height={PREVIEW_HEIGHT}
              decoding="sync"
              class="block h-auto w-full bg-background"
            />
            <Link
              to={template.href}
              target="_blank"
              class="absolute inset-0 z-10"
              aria-label={`Preview ${template.name}`}
            />
          </div>

          {/* info */}
          <div class="p-6">
            <h3 class="font-heading text-xl">{template.name as string}</h3>
            <p class="mt-1 font-base text-sm text-foreground">
              {template.description as string}
            </p>

            <div class="mt-5 grid grid-cols-2 gap-4">
              <Button
                variant="neutral"
                nativeButton={false}
                render={<Link to={template.href} target="_blank" />}
              >
                Preview
                <Eye />
              </Button>
              <InstallTemplateBtn template={template} />
            </div>
          </div>
        </div>
      }
    </div>
  </PageWrapper>
}
