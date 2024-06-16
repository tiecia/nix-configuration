import { clock, uptime } from "lib/variables"

function up(up: number) {
    const h = Math.floor(up / 60)
    const m = Math.floor(up % 60)
    return `uptime: ${h}:${m < 10 ? "0" + m : m}`
}

function updateCurrentDate(self) {
    let date = new Date()
    if(self.get_date()[1] != date.getMonth() || self.get_date()[0] != date.getFullYear()) {
        self.select_day(0)
    } else if (self.get_date()[1] != date.getMonth() || self.get_date()[0] != date.getFullYear()) {
        self.select_day(date.getDay())
    }
}

export default () => Widget.Box({
    vertical: true,
    class_name: "date-column vertical",
    children: [
        Widget.Box({
            class_name: "clock-box",
            vertical: true,
            children: [
                Widget.Label({
                    class_name: "clock",
                    label: clock.bind().as(t => t.format("%-I:%M %p")!),
                }),
                Widget.Label({
                    class_name: "uptime",
                    label: uptime.bind().as(up),
                }),
            ],
        }),
        Widget.Box({
            class_name: "calendar",
            children: [
                Widget.Calendar({
                    hexpand: true,
                    hpack: "center",
                    setup: self => {
                        self.on("month-changed", () => updateCurrentDate(self))
                    }
                }),
            ],
        }),
    ],
})
