import {
  DocsTabs,
  DocsTabsContent,
  DocsTabsList,
  DocsTabsTrigger,
} from "@/components/app/docs-tabs.tsrx"
import { Pre } from "@/components/app/pre.tsrx"
import ShadcnCliCommand from "@/components/app/shadcn-cli-command.tsrx"
import {
  getStylingInstall,
  StylingSheetContent,
  useStyling,
} from "@/components/app/styling-customizer.tsrx"
import { Button } from "@/components/ui/button.tsrx"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog.tsrx"
import { Sheet, SheetTrigger } from "@/components/ui/sheet.tsrx"

// The styling hook, the sheet and the install CSS live in
// styling-customizer.tsrx, shared with the templates toolbar.
export default function Styling() @{
  const customizer = useStyling()
  const {
    url: stylingUrl,
    css: styling,
    overrides: cliOverrides,
  } = getStylingInstall(customizer)

  <div class="flex items-center justify-center gap-4">
    <Sheet>
      <SheetTrigger render={<Button />}>Customize</SheetTrigger>
      <StylingSheetContent styling={customizer} />
    </Sheet>
    <Dialog>
      <DialogTrigger render={<Button variant="neutral" />}>Copy</DialogTrigger>
      <DialogContent class="max-h-[calc(100dvh-2rem)] overflow-y-auto sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>Install this theme</DialogTitle>
          <DialogDescription>
            Copy the command for your package manager, or paste the CSS into
            your project.
          </DialogDescription>
        </DialogHeader>
        <DocsTabs
          defaultValue="cli"
          class="min-w-0 shadow-none! [&_[data-slot=pre-wrapper]]:shadow-none [&_[data-slot=tabs]]:shadow-none"
        >
          <DocsTabsList class="grid w-full grid-cols-2">
            <DocsTabsTrigger value="cli">Shadcn CLI</DocsTabsTrigger>
            <DocsTabsTrigger value="manual">Manual</DocsTabsTrigger>
          </DocsTabsList>
          <DocsTabsContent value="cli">
            <div class="flex min-w-0 flex-col gap-4 pt-4 [&_[data-slot=pre-wrapper]]:mb-0">
              <div class="flex min-w-0 flex-col gap-2">
                <div class="mx-0.5 text-sm font-base">
                  Scaffold a new project already themed:
                </div>
                <ShadcnCliCommand command="init" url={stylingUrl} multiline />
              </div>
              <div class="flex min-w-0 flex-col gap-2">
                <div class="mx-0.5 text-sm font-base">
                  Or add to an existing project:
                </div>
                <ShadcnCliCommand command="add" url={stylingUrl} multiline />
              </div>
              <div class="flex min-w-0 flex-col gap-2">
                <div class="mx-0.5 text-sm font-base">
                  Then update these in your globals.css to match your radius,
                  shadow and font weights:
                </div>
                <Pre
                  wrapperClassName="w-full max-w-full text-white overflow-x-auto"
                  __rawstring__={cliOverrides}
                >
                  {cliOverrides as string}
                </Pre>
              </div>
            </div>
          </DocsTabsContent>
          <DocsTabsContent value="manual">
            <div class="flex min-w-0 flex-col gap-4 pt-4 [&_[data-slot=pre-wrapper]]:mb-0">
              <div class="flex min-w-0 flex-col gap-2">
                <div class="mx-0.5 text-sm font-base">
                  Paste into your globals.css. This includes your radius, shadow
                  and font weights:
                </div>
                <Pre
                  wrapperClassName="w-full max-w-full text-white overflow-x-auto"
                  __rawstring__={styling}
                >
                  {styling as string}
                </Pre>
              </div>
            </div>
          </DocsTabsContent>
        </DocsTabs>
      </DialogContent>
    </Dialog>
  </div>
}
