import { createBinding } from "ags"
import options from "options"

const { corners, transparent } = options.bar

export default (monitor: number) => (
    <window
        monitor={monitor}
        name={`corner${monitor}`}
        className="screen-corner"
        anchor={["top", "bottom", "right", "left"]}
        clickThrough
        setup={(self: any) => {
            corners.connect("changed", () => {
                self.toggleClassName("corners", corners.value)
            })
            transparent.connect("changed", () => {
                self.toggleClassName("hidden", transparent.value)
            })
        }}
    >
        <box className="shadow">
            <box className="border" expand>
                <box className="corner" expand />
            </box>
        </box>
    </window>
)
