import { clock } from "lib/variables"
import GLib from "gi://GLib?version=2.0"
import options from "options"
import icons from "lib/icons"
import BatteryBar from "widget/bar/buttons/BatteryBar"
import PanelButton from "widget/bar/PanelButton"
import { exec } from "lib/utils"
import { interval } from "lib/timer"

const { scheme } = options.theme
const { monochrome } = options.bar.powermenu
const { format } = options.bar.date

const poweroff = PanelButton({
    className: "powermenu",
    child: <icon icon={icons.powermenu.shutdown} />,
    onClicked: () => exec("shutdown now"),
    setup: (self: any) => {
        const update = () => {
            self.toggleClassName("colored", !monochrome.value)
            self.toggleClassName("box")
        }
        update()
        monochrome.connect("changed", update)
    },
})

const date = PanelButton({
    className: "date",
    child: (
        <label
            setup={(self: any) => {
                const update = () => {
                    const now = GLib.DateTime.new_now_local()
                    self.label = now.format(format.value) || ""
                }
                format.connect("changed", update)
                interval(1000, update)
                update()
            }}
        />
    ),
})

const darkmode = PanelButton({
    className: "darkmode",
    child: (
        <icon
            setup={(self: any) => {
                const update = () => {
                    self.icon = icons.color[scheme.value]
                }
                update()
                scheme.connect("changed", update)
            }}
        />
    ),
    onClicked: () => { scheme.value = scheme.value === "dark" ? "light" : "dark" },
})

export default (
    <centerbox className="bar" hexpand>
        <box $type="start" />
        {/* @ts-ignore */}
        <box $type="center">{date}</box>
        <box $type="end" hpack="end">
            {darkmode}
            {BatteryBar()}
            {poweroff}
        </box>
    </centerbox>
)
