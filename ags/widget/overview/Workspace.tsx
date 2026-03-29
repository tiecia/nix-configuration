import { createBinding } from "ags"
import Window from "./Window"
import Gdk from "gi://Gdk?version=3.0"
import Gtk from "gi://Gtk?version=3.0"
import options from "options"
 
const AstalHyprland = await import("gi://AstalHyprland")
    .then(mod => mod.default)
    .catch(() => null)

const hyprland = AstalHyprland?.get_default?.() ?? null
const TARGET = [Gtk.TargetEntry.new("text/plain", Gtk.TargetFlags.SAME_APP, 0)]
const scale = (size: number) => (options.overview.scale.value / 100) * size

const dispatch = (args: string) => hyprland?.messageAsync(`dispatch ${args}`)

const size = (id: number) => {
    const def = { h: 1080, w: 1920 }
    if (!hyprland) return def

    const ws = hyprland.get_workspace(id)
    if (!ws) return def

    const mon = hyprland.get_monitor(ws.monitorID)
    return mon ? { h: mon.height, w: mon.width } : def
}

export default ({ id }: { id: number }) => {
    let fixed_ref: any = null

    const update = async () => {
        if (!hyprland) return
        if (!fixed_ref) return

        const json = await hyprland.messageAsync("j/clients").catch(() => null)
        if (!json) return

        fixed_ref.get_children().forEach((ch: any) => ch.destroy())
        const clients = JSON.parse(json) as typeof hyprland.clients
        clients
            .filter(({ workspace }: any) => workspace.id === id)
            .forEach((c: any) => {
                const x = c.at[0] - (hyprland.get_monitor(c.monitor)?.x || 0)
                const y = c.at[1] - (hyprland.get_monitor(c.monitor)?.y || 0)
                if (c.mapped && fixed_ref) {
                    fixed_ref.put(Window({ client: c }), scale(x), scale(y))
                }
            })
        fixed_ref.show_all()
    }

    return (
        <box
            attribute={{ id }}
            tooltipText={`${id}`}
            className="workspace"
            vpack="center"
            css={createBinding(options.overview.scale).as((v: number) => `
                min-width: ${(v / 100) * size(id).w}px;
                min-height: ${(v / 100) * size(id).h}px;
            `)}
            setup={(self: any) => {
                if (!hyprland) return
                options.overview.scale.connect("changed", update)
                hyprland.connect("notify::clients", update)
                hyprland.connect("notify::active-client", update)
                hyprland.connect("notify::active-workspace", () => {
                    self.toggleClassName("active", hyprland.active.workspace.id === id)
                })
                update()
            }}
        >
            <eventbox
                expand
                onPrimaryClick={() => {
                    const win = globalThis.app?.get_window("overview")
                    if (win) win.set_visible(false)
                    dispatch(`workspace ${id}`)
                }}
                setup={(self: any) => {
                    self.drag_dest_set(Gtk.DestDefaults.ALL, TARGET, Gdk.DragAction.COPY)
                    self.connect("drag-data-received", (_w: any, _c: any, _x: any, _y: any, data: any) => {
                        const address = new TextDecoder().decode(data.get_data())
                        dispatch(`movetoworkspacesilent ${id},address:${address}`)
                    })
                }}
            >
                <fixed
                    ref={(ref: any) => { fixed_ref = ref }}
                    expand
                />
            </eventbox>
        </box>
    )
}
