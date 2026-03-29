import { Menu, ArrowToggleButton } from "../ToggleButton"
import { createBinding } from "ags"
import AstalNetwork from "gi://AstalNetwork"
import Gtk from "gi://Gtk?version=3.0"
import { Menu, ArrowToggleButton } from "../ToggleButton"
import icons from "lib/icons.js"
import { dependencies, sh, execAsync } from "lib/utils"
import { idle } from "lib/timer"
import options from "options"

const network = AstalNetwork.get_default()
const wifi = network.wifi

export const NetworkToggle = () => ArrowToggleButton({
    name: "network",
    icon: createBinding(wifi, "iconName") as any,
    label: createBinding(wifi, "ssid").as((ssid: string) => ssid || "Not Connected") as any,
    connection: [wifi, () => wifi.enabled],
    deactivate: () => { wifi.enabled = false },
    activate: () => {
        wifi.enabled = true
        wifi.scan()
    },
})

const ApList = () => (
    <box
        vertical
        setup={(self: any) => {
            const update = () => {
                self.children = (wifi.accessPoints as any[])
                    .sort((a: any, b: any) => b.strength - a.strength)
                    .slice(0, 10)
                    .map((ap: any) => (
                        <button
                            onClicked={() => {
                                if (dependencies("nmcli"))
                                    execAsync(`nmcli device wifi connect ${ap.bssid}`)
                            }}
                        >
                            <box>
                                <icon icon={ap.iconName} />
                                <label label={ap.ssid || ""} />
                                <icon
                                    icon={icons.ui.tick}
                                    hexpand
                                    hpack="end"
                                    setup={(tick: any) => {
                                        idle(() => {
                                            if (!tick.is_destroyed)
                                                tick.visible = ap.active
                                        })
                                    }}
                                />
                            </box>
                        </button>
                    ))
            }
            update()
            wifi.connect("notify::access-points", update)
        }}
    />
)

export const WifiSelection = () => Menu({
    name: "network",
    icon: createBinding(wifi, "iconName") as any,
    title: "Wifi Selection",
    content: [
        ApList() as any,
        new Gtk.Separator({ visible: true }),
        (
            <button onClicked={() => sh(options.quicksettings.networkSettings.value)}>
                <box>
                    <icon icon={icons.ui.settings} />
                    <label label="Network" />
                </box>
            </button>
        ) as any,
    ],
})
