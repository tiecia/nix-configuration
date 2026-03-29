import { createBinding } from "ags"
import { type TrayItem } from "types/service/systemtray"
import PanelButton from "../PanelButton"
import Gdk from "gi://Gdk?version=3.0"
import options from "options"

const Tray = await import("gi://AstalTray")
    .then(mod => mod.default)
    .catch(() => null)

const systemtray = Tray?.get_default?.() ?? null
const { ignore } = options.bar.systray

const SysTrayItem = (item: TrayItem) => {
    let menu_id: any = null

    return PanelButton({
        className: "tray-item",
        tooltipMarkup: createBinding(item, "tooltip").as((tooltip: string) => tooltip || ""),
        onPrimaryClick: (btn: any) => {
            if (item.menu) {
                item.menu.popup_at_widget(btn, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
            }
        },
        onSecondaryClick: (btn: any) => {
            if (item.menu) {
                item.menu.popup_at_widget(btn, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
            }
        },
        setup: (self: any) => {
            const { menu } = item
            if (!menu) return

            menu_id = menu.connect("popped-up", () => {
                self.toggleClassName("active")
                menu.connect("notify::visible", () => {
                    self.toggleClassName("active", menu.visible)
                })
                if (menu_id) menu.disconnect(menu_id)
            })

            self.connect("destroy", () => {
                if (menu_id) menu.disconnect(menu_id)
            })
        },
        child: (
            <box>
                <icon icon={createBinding(item, "icon")} />
            </box>
        ),
    })
}

export default () => (
    systemtray
        ? (
            <box>
                {createBinding(systemtray, "items").as((items: TrayItem[]) =>
                    items
                        .filter(({ id }) => !ignore.value.includes(id))
                        .map(SysTrayItem)
                )}
            </box>
        )
        : <box />
)
