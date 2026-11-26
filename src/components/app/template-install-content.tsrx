import type { OctaneNode } from "octane"

import type { Template } from "@/data/templates"

import { Pre } from "@/components/app/pre.tsrx"
import ShadcnCliCommand from "@/components/app/shadcn-cli-command.tsrx"
import {
  getStylingInstall,
  type Styling,
} from "@/components/app/styling-customizer.tsrx"
import {
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog.tsrx"

function Step({ label, children }: { label: string; children?: OctaneNode }) @{
  <div class="flex min-w-0 flex-col gap-2">
    <div class="mx-0.5 text-sm font-base">{label}</div>
    {children}
  </div>
}

// Install instructions for a template registry item with the given styling.
// A template installs as components; the last step renders its root
// component from a route of the reader's app.
export default function TemplateInstallContent({
  template,
  styling,
}: {
  template: Template
  styling: Styling
}) @{
  const install = getStylingInstall(styling)
  const usage = `import ${template.component} from "${template.importPath}"

// In the route or page that should show the template:
<${template.component} />`

  <DialogContent class="max-h-[calc(100dvh-2rem)] overflow-y-auto sm:max-w-2xl">
    <DialogHeader>
      <DialogTitle>Install this template</DialogTitle>
      <DialogDescription>
        Set up a new project with this template using the shadcn CLI.
      </DialogDescription>
    </DialogHeader>
    <div class="flex min-w-0 flex-col gap-5 [&_[data-slot=pre-wrapper]]:mb-0">
      <Step
        label={`1. Create a project with the ${styling.palette.name}${styling.mode === "duotone" ? " duotone" : ""} styling:`}
      >
        <ShadcnCliCommand url={install.url} command="init" multiline />
      </Step>

      <Step label="2. Add the template. Run this inside your new project:">
        <ShadcnCliCommand url={template.registryItem} multiline />
      </Step>

      @if (install.hasOverrides) {
        <Step label="3. Update these in your globals.css to match your radius, shadow and font weights:">
          <Pre
            wrapperClassName="w-full max-w-full text-white overflow-x-auto"
            __rawstring__={install.overrides}
          >
            {install.overrides as string}
          </Pre>
        </Step>
      }

      <Step
        label={`${install.hasOverrides ? "4" : "3"}. Render the template from one of your routes:`}
      >
        <Pre
          wrapperClassName="w-full max-w-full text-white overflow-x-auto"
          __rawstring__={usage}
        >
          {usage as string}
        </Pre>
      </Step>
    </div>
  </DialogContent>
}
