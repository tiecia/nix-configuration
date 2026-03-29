import GLib from "gi://GLib?version=2.0"
import PanelButton from "../PanelButton"
import options from "options"
import { interval } from "lib/timer"

const { format, action } = options.bar.date

export default () => PanelButton({
    window: "datemenu",
    onClicked: () => action.value(),
    child: (
        <label
            justification="center"
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
