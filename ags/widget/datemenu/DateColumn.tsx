import Gtk from "gi://Gtk?version=3.0"
import { clock, uptime } from "lib/variables"
import { interval } from "lib/timer"

function up(minutes: number) {
    const h = Math.floor(minutes / 60)
    const m = Math.floor(minutes % 60)
    return `uptime: ${h}:${m < 10 ? "0" + m : m}`
}

function updateCurrentDate(self: any) {
    const date = new Date()
    const [year, month] = self.get_date()
    if (month !== date.getMonth() || year !== date.getFullYear()) {
        self.select_day(0)
    } else {
        self.select_day(date.getDate())
    }
}

export default () => (
    <box vertical className="date-column vertical">
        <box className="clock-box" vertical>
            <label
                className="clock"
                setup={(self: any) => {
                    const update = () => {
                        self.label = clock.value.format("%-I:%M %p") ?? ""
                    }
                    update()
                    clock.connect("changed", update)
                }}
            />
            <label
                className="uptime"
                setup={(self: any) => {
                    const update = () => {
                        self.label = up(uptime.value)
                    }
                    update()
                    uptime.connect("changed", update)
                }}
            />
        </box>
        <box className="calendar">
            <Gtk.Calendar
                hexpand
                hpack="center"
                setup={(self: any) => {
                    self.connect("month-changed", () => updateCurrentDate(self))
                }}
            />
        </box>
    </box>
)
