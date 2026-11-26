import { ArrowLeft, Download, Paintbrush } from "@octanejs/lucide"
import { Link, useLocation } from "@octanejs/tanstack-router"
import { useEffect, useState } from "octane"

import { getTemplate } from "@/data/templates"

import {
  StylingSheetContent,
  useStyling,
} from "@/components/app/styling-customizer.tsrx"
import TemplateInstallContent from "@/components/app/template-install-content.tsrx"
import { Button } from "@/components/ui/button.tsrx"
import { Dialog, DialogTrigger } from "@/components/ui/dialog.tsrx"
import { Sheet, SheetTrigger } from "@/components/ui/sheet.tsrx"

// Floating dock on template pages: a link back to the templates list, the
// same styling sheet as the styling page (so changes here also apply to the
// docs), and install instructions for the template with the current styling.
export default function TemplateToolbar() @{
  const styling = useStyling()
  const pathname = useLocation({ select: (location) => location.pathname })
  // Hidden until mounted, and inside iframes that embed a template.
  const [visible, setVisible] = useState(false)

  useEffect(() => {
    setVisible(window.self === window.top)
  }, [])

  const template = getTemplate(pathname.replace(/\/$/, ""))

  @if (visible) {
    <div
      role="toolbar"
      aria-label="Template tools"
      class="fixed bottom-4 left-1/2 z-50 flex -translate-x-1/2 items-center gap-1.5 rounded-base border-2 border-border bg-secondary-background p-1.5 shadow-shadow sm:bottom-6 sm:gap-2 sm:p-2"
    >
      <Button
        variant="noShadow"
        nativeButton={false}
        render={<Link to="/templates" />}
        aria-label="Back to templates"
        class="bg-secondary-background px-3 text-foreground sm:px-4"
      >
        <ArrowLeft />
        <span class="hidden min-[400px]:inline">Templates</span>
      </Button>
      <Sheet>
        <SheetTrigger
          render={
            <Button
              variant="noShadow"
              aria-label="Customize styling"
              class="bg-secondary-background px-3 text-foreground sm:px-4"
            />
          }
        >
          Customize
          <Paintbrush />
        </SheetTrigger>
        <StylingSheetContent styling={styling} />
      </Sheet>
      @if (template) {
        <Dialog>
          <DialogTrigger
            render={<Button variant="noShadow" class="px-3 sm:px-4" />}
          >
            Install
            <Download />
          </DialogTrigger>
          <TemplateInstallContent template={template} styling={styling} />
        </Dialog>
      }
    </div>
  }
}
