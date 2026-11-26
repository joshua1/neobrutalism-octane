import { Menu, X } from "@octanejs/lucide"
import { useState } from "octane"

import { Button } from "@/components/ui/button.tsrx"

const LINKS = [
  { label: "Features", href: "#features" },
  { label: "Product", href: "#product" },
  { label: "Pricing", href: "#pricing" },
  { label: "FAQ", href: "#faq" },
]

export default function Navbar() @{
  const [open, setOpen] = useState(false)

  <header class="sticky top-0 z-40 border-b-4 border-border bg-secondary-background">
    <div class="mx-auto flex h-16 w-full max-w-6xl items-center justify-between px-5">
      <a href="#" class="flex items-center gap-3 font-heading text-xl">
        <span class="flex size-8 items-center justify-center rounded-base border-2 border-border bg-main text-main-foreground">
          P
        </span>
        Planly
      </a>

      <nav class="hidden items-center gap-8 text-sm font-base md:flex">
        @for (const link of LINKS; key link.href) {
          <a
            href={link.href}
            class="decoration-2 underline-offset-4 hover:underline"
          >
            {link.label as string}
          </a>
        }
      </nav>

      <div class="hidden items-center gap-3 md:flex">
        <Button variant="neutral" size="sm">
          Sign in
        </Button>
        <Button size="sm">Start free trial</Button>
      </div>

      <Button
        variant="neutral"
        size="icon-sm"
        class="md:hidden"
        aria-label={open ? "Close menu" : "Open menu"}
        aria-expanded={open}
        onClick={() => setOpen((o) => !o)}
      >
        @if (open) {
          <X />
        } @else {
          <Menu />
        }
      </Button>
    </div>

    @if (open) {
      <div class="border-t-4 border-border md:hidden">
        <nav class="mx-auto flex w-full max-w-6xl flex-col gap-1 px-5 py-4">
          @for (const link of LINKS; key link.href) {
            <a
              href={link.href}
              onClick={() => setOpen(false)}
              class="rounded-base px-3 py-2 font-base hover:bg-background"
            >
              {link.label as string}
            </a>
          }
          <div class="mt-3 grid grid-cols-2 gap-3">
            <Button variant="neutral">Sign in</Button>
            <Button>Start free trial</Button>
          </div>
        </nav>
      </div>
    }
  </header>
}
