import { useState } from "octane"

import { Avatar, AvatarFallback } from "@/components/ui/avatar.tsrx"
import { Button } from "@/components/ui/button.tsrx"
import { Input } from "@/components/ui/input.tsrx"
import { Label } from "@/components/ui/label.tsrx"
import { Switch } from "@/components/ui/switch.tsrx"

import { NOTIFICATIONS, USER } from "./data"
import { ChartCard } from "./shared.tsrx"

const FIELDS = [
  { name: "name", label: "Name", type: "text", autoComplete: "name" },
  { name: "email", label: "Email", type: "email", autoComplete: "email" },
  { name: "role", label: "Role", type: "text", autoComplete: "off" },
  { name: "store", label: "Store", type: "text", autoComplete: "off" },
] as const

export default function Profile() @{
  const [saved, setSaved] = useState(false)

  <div class="grid items-start gap-5 xl:grid-cols-3">
    <ChartCard
      title="Your details"
      description="Shown to your team and on exported reports"
      class="xl:col-span-2"
    >
      <form
        class="flex flex-col gap-5"
        onInput={() => setSaved(false)}
        onSubmit={(event: SubmitEvent) => {
          event.preventDefault()
          // Send the form to your API here.
          setSaved(true)
        }}
      >
        <div class="flex items-center gap-4">
          <Avatar size="lg">
            <AvatarFallback class="bg-chart-3">
              {USER.initials as string}
            </AvatarFallback>
          </Avatar>
          <div class="min-w-0">
            <p class="truncate font-heading text-lg">{USER.name as string}</p>
            <p class="truncate text-sm">{`Member since ${USER.since}`}</p>
          </div>
        </div>
        <div class="grid gap-5 sm:grid-cols-2">
          @for (const { name, label, ...field } of FIELDS; key name) {
            <div class="flex flex-col gap-2">
              <Label for={`profile-${name}`}>{label as string}</Label>
              <Input
                id={`profile-${name}`}
                name={name}
                defaultValue={USER[name]}
                required
                {...field}
              />
            </div>
          }
        </div>
        <div class="flex items-center gap-4">
          <Button type="submit">Save changes</Button>
          <p aria-live="polite" class="text-sm">
            {(saved ? "Changes saved." : "") as string}
          </p>
        </div>
      </form>
    </ChartCard>

    <ChartCard title="Notifications" description="Sent to your email">
      <ul class="flex flex-col gap-5">
        @for (const item of NOTIFICATIONS; key item.id) {
          <li class="flex items-center justify-between gap-4">
            <div class="flex flex-col gap-1.5">
              <Label for={`notify-${item.id}`}>{item.label as string}</Label>
              <p id={`notify-${item.id}-text`} class="text-sm">
                {item.description as string}
              </p>
            </div>
            <Switch
              id={`notify-${item.id}`}
              aria-describedby={`notify-${item.id}-text`}
              defaultChecked={item.enabled}
            />
          </li>
        }
      </ul>
    </ChartCard>
  </div>
}
