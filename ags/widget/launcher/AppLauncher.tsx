import { createBinding } from "ags"
import AstalApps from "gi://AstalApps"
import Gtk from "gi://Gtk?version=3.0"
import { launchApp, icon } from "lib/utils"
import options from "options"
import icons from "lib/icons"

const apps = AstalApps.get_default()
const { iconSize } = options.launcher.apps

const QuickAppButton = (app: any) => (
    <button
        hexpand
        tooltipText={app.name}
        onClicked={() => {
            globalThis.app?.get_window("launcher")?.set_visible(false)
            launchApp(app)
        }}
    >
        <icon
            size={iconSize.value}
            icon={icon(app.iconName ?? app.icon_name ?? "", icons.fallback.executable)}
        />
    </button>
)

const AppItem = (app: any) => {
    const title = (
        <label
            className="title"
            label={app.name}
            hexpand
            xalign={0}
            vpack="center"
            truncate="end"
        />
    )

    const description = (
        <label
            className="description"
            label={app.description || ""}
            hexpand
            wrap
            maxWidthChars={30}
            xalign={0}
            justification="left"
            vpack="center"
        />
    )

    const appicon = (
        <icon
            icon={icon(app.iconName ?? app.icon_name ?? "", icons.fallback.executable)}
            size={iconSize.value}
        />
    )

    const textBox = (
        <box vertical vpack="center">
            {title}
            {app.description ? description : null}
        </box>
    )

    return (
        <button
            className="app-item"
            onClicked={() => {
                globalThis.app?.get_window("launcher")?.set_visible(false)
                launchApp(app)
            }}
        >
            <box>
                {appicon}
                {textBox}
            </box>
        </button>
    ) as any
}

export function Favorites() {
    const favs = options.launcher.apps.favorites

    return (
        <revealer
            setup={(self: any) => {
                const update = () => {
                    const f = favs.value as string[][]
                    self.visible = f.length > 0
                    // rebuild inner box children
                }}
            }}
        >
            <box vertical>
                {(favs.value as string[][]).flatMap(fs => [
                    new Gtk.Separator({ visible: true }),
                    (
                        <box className="quicklaunch horizontal">
                            {fs
                                .map((f: string) => apps.fuzzy_query?.(f)?.[0])
                                .filter((f: any) => f)
                                .map(QuickAppButton)}
                        </box>
                    ) as any,
                ])}
            </box>
        </revealer>
    ) as any
}

export function Launcher() {
    const max = options.launcher.apps.max
    let first: any = null

    const SeparatedAppItem = (app: any) => {
        return (
            <revealer>
                <box vertical>
                    <Gtk.Separator visible />
                    {AppItem(app)}
                </box>
            </revealer>
        ) as any
    }

    const list = (
        <box
            vertical
            setup={(self: any) => {
                const rebuild = () => {
                    const results = apps.fuzzy_query?.("") ?? []
                    self.children = results.map(SeparatedAppItem)
                    if (results[0]) first = results[0]
                }
                rebuild()
                apps.connect("notify::frequents", rebuild)
            }}
        />
    ) as any

    return Object.assign(list, {
        filter(text: string | null) {
            const results = apps.fuzzy_query?.(text || "") ?? []
            first = results[0] ?? null

            list.children.forEach((item: any, i: number) => {
                if (!text || i >= max.value) {
                    item.revealChild = false
                } else {
                    item.revealChild = true
                }
            })
        },
        launchFirst() {
            if (first) launchApp(first)
        },
    })
}
