import icons from "lib/icons"
import { createBinding } from "ags"
import options from "options"
import powermenu, { Action } from "service/powermenu"

const Battery = await import("gi://AstalBattery")
    .then(mod => mod.default)
    .catch(() => null)

const battery = Battery?.get_default?.() ?? null

function fmtTime(sec: number) {
    const h = Math.floor(sec / 3600)
    const m = Math.floor(sec % 3600 / 60)
    return `${h}h ${m < 10 ? "0" + m : m}m`
}

const SysButton = (action: Action) => (
    <button vpack="center" onClicked={() => powermenu.action(action)}>
        <icon icon={icons.powermenu[action]} />
    </button>
)

export const Header = () => (
    <box className="header horizontal">
        <box vertical vpack="center">
            <box
                setup={(self: any) => {
                    if (!battery) {
                        self.visible = false
                        return
                    }
                    const update = () => { self.visible = battery.percent > 0 }
                    update()
                    battery.connect("notify", update)
                }}
            >
                <icon
                    setup={(self: any) => {
                        if (!battery) return
                        const update = () => { self.icon = battery.icon_name }
                        update()
                        battery.connect("notify", update)
                    }}
                />
                <label label={battery ? createBinding(battery, "percent").as((p: number) => `${p}%`) : ""} />
            </box>
            <box
                setup={(self: any) => {
                    if (!battery) {
                        self.visible = false
                        return
                    }
                    const update = () => { self.visible = battery.percent > 0 }
                    update()
                    battery.connect("notify", update)
                }}
            >
                <icon icon={icons.ui.time} />
                <label
                    setup={(self: any) => {
                        if (!battery) {
                            self.label = ""
                            return
                        }
                        const update = () => {
                            const t = (battery as any).timeToFull || (battery as any).time_to_full || 0
                            self.label = fmtTime(t)
                        }
                        update()
                        battery.connect("notify", update)
                    }}
                />
            </box>
        </box>
        <box hexpand />
        <button
            vpack="center"
            onClicked={() => {
                globalThis.app?.get_window("quicksettings")?.set_visible(false)
                globalThis.app?.get_window("settings-dialog")?.set_visible(false)
                globalThis.app?.get_window("settings-dialog")?.set_visible(true)
            }}
        >
            <icon icon={icons.ui.settings} />
        </button>
        {SysButton("logout")}
        {SysButton("shutdown")}
    </box>
)
