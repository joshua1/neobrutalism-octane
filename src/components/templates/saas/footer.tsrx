const LINKS = {
  Product: ["Features", "Pricing", "Changelog", "Roadmap", "Integrations"],
  Company: ["About", "Blog", "Careers", "Customers"],
  Resources: ["Docs", "API reference", "Guides", "Status"],
  Legal: ["Privacy", "Terms", "Security", "DPA"],
}

export default function Footer() @{
  <footer class="bg-secondary-background px-5 py-16">
    <div class="mx-auto w-full max-w-6xl">
      <div class="grid grid-cols-2 gap-x-6 gap-y-10 sm:grid-cols-4 lg:grid-cols-6">
        <div class="col-span-2 sm:col-span-4 lg:col-span-2">
          <a href="#" class="flex items-center gap-3 font-heading text-xl">
            <span class="flex size-8 items-center justify-center rounded-base border-2 border-border bg-main text-main-foreground">
              P
            </span>
            Planly
          </a>
          <p class="mt-4 max-w-xs text-sm font-base">
            The fast, focused project tracker for teams that ship.
          </p>
        </div>

        @for (const [category, links] of Object.entries(LINKS); key category) {
          <div>
            <p class="font-heading text-lg">{category as string}</p>
            <ul class="mt-3 space-y-1">
              @for (const link of links; key link) {
                <li>
                  <a
                    href="#"
                    class="inline-block py-1.5 text-sm font-base decoration-2 underline-offset-4 hover:underline"
                  >
                    {link as string}
                  </a>
                </li>
              }
            </ul>
          </div>
        }
      </div>

      <p class="mt-14 text-center text-sm font-base">
        © 2026 Planly Inc. All rights reserved.
      </p>
    </div>
  </footer>
}
