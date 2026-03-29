import { createBinding } from "ags"
import { icon as getIcon } from "lib/utils"
import icons from "lib/icons"
import options from "options"
import PanelButton from "../PanelButton"
 
const AstalHyprland = await import("gi://AstalHyprland")
    .then(mod => mod.default)
    .catch(() => null)

const hyprland = AstalHyprland?.get_default?.() ?? null
const { monochrome, exclusive, iconSize } = options.bar.taskbar
const { position } = options.bar

const focus = (address: string) => hyprland?.messageAsync(
    `dispatch focuswindow address:${address}`)

const AppItem = (address: string) => {
    let item_ref: any = null
    if (!hyprland) return <box visible={false} />

    const client = hyprland.get_client(address)

    if (!client || !client.class) {
        return <box visible={false} />
    }

    return (
        <box
            key={address}
            visible={
                exclusive.value
                    ? hyprland.active.workspace.id === client.workspace.id
                    : true
            }
            setup={(self: any) => {
                item_ref = self;
                (self as any).attribute = { address }
            }}
        >
            <PanelButton
                onPrimaryClick={() => focus(address)}
                child={
                    <icon
                        size={createBinding(iconSize)}
                        icon={createBinding(monochrome).as((m: boolean) =>
                            getIcon(
                                client.class + (m ? "-symbolic" : ""),
                                icons.fallback.executable + (m ? "-symbolic" : "")
                            )
                        )}
                    />
                }
            />
            <overlay
                passThrough
                class="indicator"
                hpack="center"
                vpack={createBinding(position).as((p: string) => p === "top" ? "start" : "end")}
                setup={(self: any) => {
                    hyprland.connect("notify", () => {
                        self.toggleClassName("active", hyprland.active.client.address === address)
                    })
                }}
            >
                <label />
            </overlay>
        </box>
    )
}

const sortItems = (items: any[]) => {
    if (!hyprland) return items

    return items.sort((a, b) => {
        const aclient = hyprland.get_client((a as any).attribute?.address)
        const bclient = hyprland.get_client((b as any).attribute?.address)
        if (!aclient || !bclient) return 0
        return aclient.workspace.id - bclient.workspace.id
    })
}

export default () => {
    let box_ref: any = null

    return (
        <box
            class="taskbar"
            setup={(w: any) => {
                if (!hyprland) return
                box_ref = w
                w.children = sortItems(hyprland.clients.map((c: any) => AppItem(c.address)))

                hyprland.connect("notify::clients", () => {
                    if (box_ref) {
                        box_ref.children = sortItems(hyprland.clients.map((c: any) =>
                            AppItem(c.address)
                        ))
                    }
                })
            }}
        />
    )
}
