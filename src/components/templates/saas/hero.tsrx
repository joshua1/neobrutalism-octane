import {
  ArrowRight,
  Bot,
  Plus,
  RotateCcw,
  Sparkles,
  TrendingDown,
} from "@octanejs/lucide"
import { useRef, useState } from "octane"

import Star14 from "@/components/stars/s14.tsrx"
import Star26 from "@/components/stars/s26.tsrx"
import { Button } from "@/components/ui/button.tsrx"

import { cn } from "@/lib/utils"

import { GRID_BACKGROUND, SectionStars } from "./decor-star.tsrx"

type Status = "todo" | "progress" | "done"

type Task = {
  id: string
  title: string
  tag: string
  tagColor: string
  status: Status
  agent?: boolean
}

const COLUMNS: { id: Status; title: string }[] = [
  { id: "todo", title: "Todo" },
  { id: "progress", title: "In progress" },
  { id: "done", title: "Done" },
]

const NEXT_STATUS: Record<Status, Status> = {
  todo: "progress",
  progress: "done",
  done: "todo",
}

const INITIAL_TASKS: Task[] = [
  {
    id: "PLN-142",
    title: "Onboarding checklist v2",
    tag: "Design",
    tagColor: "bg-chart-5",
    status: "todo",
  },
  {
    id: "PLN-139",
    title: "Rate limit the public API",
    tag: "Backend",
    tagColor: "bg-chart-2",
    status: "todo",
  },
  {
    id: "PLN-131",
    title: "Usage-based billing",
    tag: "Billing",
    tagColor: "bg-chart-4",
    status: "progress",
    agent: true,
  },
  {
    id: "PLN-128",
    title: "Fix flaky e2e tests",
    tag: "Infra",
    tagColor: "bg-chart-3",
    status: "progress",
  },
  {
    id: "PLN-120",
    title: "Dark mode for dashboard",
    tag: "Design",
    tagColor: "bg-chart-5",
    status: "done",
  },
  {
    id: "PLN-117",
    title: "Slack notifications",
    tag: "Integrations",
    tagColor: "bg-chart-1",
    status: "done",
  },
]

const NEW_ISSUES = [
  { title: "Write release notes", tag: "Docs", tagColor: "bg-chart-3" },
  { title: "Audit onboarding emails", tag: "Growth", tagColor: "bg-chart-4" },
  { title: "Fix avatar upload", tag: "Bug", tagColor: "bg-chart-2" },
  { title: "Add SSO to admin panel", tag: "Security", tagColor: "bg-chart-5" },
]

const titleOf = (status: Status) =>
  COLUMNS.find((column) => column.id === status)!.title

function TaskBoard() @{
  const [tasks, setTasks] = useState(INITIAL_TASKS)
  const [dragId, setDragId] = useState<string | null>(null)
  const [overColumn, setOverColumn] = useState<Status | null>(null)
  const [activity, setActivity] = useState({
    actor: "Agent",
    text: "moved PLN-131 to In progress",
  })
  const nextNumber = useRef(143)

  function move(id: string, to: Status) {
    setTasks((current) => {
      const task = current.find((t) => t.id === id)
      if (!task || task.status === to) return current
      return [...current.filter((t) => t.id !== id), { ...task, status: to }]
    })
    setActivity({ actor: "You", text: `moved ${id} to ${titleOf(to)}` })
  }

  function addIssue() {
    const id = `PLN-${nextNumber.current}`
    const template = NEW_ISSUES[nextNumber.current % NEW_ISSUES.length]
    nextNumber.current += 1
    setTasks((current) => [...current, { id, ...template, status: "todo" }])
    setActivity({ actor: "You", text: `created ${id}` })
  }

  <div class="relative mx-auto w-full max-w-5xl">
    <div class="absolute -right-2 -top-5 z-10 flex rotate-3 items-center gap-1.5 rounded-base border-2 border-border bg-chart-3 px-3 py-1.5 text-sm font-heading shadow-shadow">
      <TrendingDown class="size-4" /> Cycle time −32%
    </div>

    <div class="overflow-hidden rounded-base border-2 border-border bg-background shadow-shadow">
      <div class="flex items-center justify-between border-b-2 border-border bg-background px-4 py-2.5">
        <div class="flex flex-1 items-center gap-1.5">
          <span class="size-3 rounded-full border-2 border-border bg-chart-2" />
          <span class="size-3 rounded-full border-2 border-border bg-chart-3" />
          <span class="size-3 rounded-full border-2 border-border bg-chart-4" />
          <span class="ml-3 hidden text-xs font-base md:inline">
            Drag cards to move them
          </span>
        </div>
        <span class="shrink-0 text-xs font-heading">Sprint 24 · Planly</span>
        <span class="flex-1" />
      </div>

      <div class="grid auto-cols-[78%] grid-flow-col gap-3 overflow-x-auto p-4 pb-12 sm:auto-cols-auto sm:grid-flow-row sm:grid-cols-3 sm:gap-5 sm:overflow-visible sm:p-6 sm:pb-12">
        @for (const column of COLUMNS; key column.id) {
          const columnTasks = tasks.filter((t) => t.status === column.id)

          <div
            onDragOver={(e: DragEvent) => {
              e.preventDefault()
              setOverColumn(column.id)
            }}
            onDragLeave={(e: DragEvent) => {
              const target = e.currentTarget as HTMLElement
              if (!target.contains(e.relatedTarget as Node)) {
                setOverColumn(null)
              }
            }}
            onDrop={(e: DragEvent) => {
              e.preventDefault()
              const id = e.dataTransfer?.getData("text/plain")
              if (id) move(id, column.id)
              setOverColumn(null)
              setDragId(null)
            }}
            class={cn(
              "-m-2 flex flex-col gap-3 rounded-base border-2 border-transparent p-2 transition-colors",
              overColumn === column.id &&
                dragId &&
                "border-dashed border-border bg-secondary-background",
            )}
          >
            <div class="flex items-center justify-between text-xs font-heading">
              {column.title as string}
              <span class="rounded-base border-2 border-border bg-secondary-background px-1.5">
                {String(columnTasks.length)}
              </span>
            </div>

            @for (const task of columnTasks; key task.id) {
              <div
                draggable
                onDragStart={(e: DragEvent) => {
                  if (e.dataTransfer) {
                    e.dataTransfer.setData("text/plain", task.id)
                    e.dataTransfer.effectAllowed = "move"
                  }
                  setDragId(task.id)
                }}
                onDragEnd={() => {
                  setDragId(null)
                  setOverColumn(null)
                }}
                class={cn(
                  "cursor-grab rounded-base border-2 border-border bg-secondary-background p-3 shadow-[2px_2px_0_0_var(--border)] active:cursor-grabbing",
                  dragId === task.id && "border-dashed shadow-none",
                )}
              >
                <div class="flex items-center justify-between text-[11px] font-base">
                  <span class="flex items-center gap-1.5">
                    {task.id as string}
                    @if (task.agent) {
                      <Bot class="size-3.5" />
                    }
                  </span>
                  <button
                    type="button"
                    onClick={() => move(task.id, NEXT_STATUS[task.status])}
                    aria-label={`Move ${task.id} to ${titleOf(NEXT_STATUS[task.status])}`}
                    class="flex size-6 items-center justify-center rounded-base border-2 border-border bg-main text-main-foreground transition-transform hover:translate-x-px hover:translate-y-px"
                  >
                    @if (task.status === "done") {
                      <RotateCcw class="size-3" />
                    } @else {
                      <ArrowRight class="size-3" />
                    }
                  </button>
                </div>
                <p
                  class={cn(
                    "mt-1 text-sm font-heading leading-snug",
                    task.status === "done" && "line-through",
                  )}
                >
                  {task.title as string}
                </p>
                <span
                  class={cn(
                    "mt-2 inline-block rounded-base border-2 border-border px-1.5 text-[10px] font-heading",
                    task.tagColor,
                  )}
                >
                  {task.tag as string}
                </span>
              </div>
            }

            @if (column.id === "todo") {
              <button
                type="button"
                onClick={addIssue}
                class="flex items-center justify-center gap-1.5 rounded-base border-2 border-dashed border-border px-3 py-2 text-xs font-heading transition-colors hover:bg-main hover:text-main-foreground"
              >
                <Plus class="size-3.5" /> New issue
              </button>
            }
          </div>
        }
      </div>
    </div>

    <div
      aria-live="polite"
      class="absolute -bottom-6 -left-2 z-10 flex -rotate-3 items-center gap-2 rounded-base border-2 border-border bg-secondary-background px-3 py-2 text-sm font-base shadow-shadow sm:-left-6"
    >
      <span class="flex size-6 items-center justify-center rounded-base border-2 border-border bg-chart-3">
        <Sparkles class="size-3.5" />
      </span>
      <span>
        <span class="font-heading">{activity.actor as string}</span>{" "}
        {activity.text as string}
      </span>
    </div>
  </div>
}

export default function Hero() @{
  <section
    class={cn(
      "relative isolate overflow-hidden border-b-4 border-border bg-secondary-background",
      GRID_BACKGROUND,
    )}
  >
    <SectionStars
      stars={[
        {
          star: Star14,
          color: "var(--chart-3)",
          class: "-left-16 lg:-left-12 top-8 size-24 rotate-[15deg] lg:size-40",
        },
        {
          star: Star26,
          color: "var(--chart-4)",
          class:
            "-right-16 lg:-right-12 top-[30%] size-24 -rotate-[40deg] lg:size-40",
        },
      ]}
    />
    <div class="mx-auto flex w-full max-w-6xl flex-col items-center gap-16 px-5 py-20 lg:py-24">
      <div class="flex flex-col items-center gap-7 text-center">
        <h1 class="font-heading text-4xl leading-[1.05] tracking-tight sm:text-5xl lg:text-6xl">
          Plan less.
          <br />
          Ship{" "}
          <span class="inline-block -rotate-2 rounded-base border-2 border-border bg-chart-3 px-3 shadow-shadow">
            more.
          </span>
        </h1>

        <p class="max-w-xl text-lg font-base">
          Planly is the project tracker for teams that move fast. Issues,
          roadmaps and AI triage in one fast, focused workspace.
        </p>

        <div class="flex flex-wrap justify-center gap-3 sm:gap-4">
          <Button class="sm:h-11 sm:px-8">Start free trial</Button>
          <Button variant="neutral" class="sm:h-11 sm:px-8">
            Book a demo
          </Button>
        </div>
      </div>

      <TaskBoard />
    </div>
  </section>
}
