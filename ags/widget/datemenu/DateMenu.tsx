import GLib from "gi://GLib?version=2.0"
import Gtk from "gi://Gtk?version=3.0"
import PopupWindow from "widget/PopupWindow"
import options from "options"

const { bar, datemenu } = options

function DateMenuContent() {
    const now = GLib.DateTime.new_now_local()

    return (
        <box class="datemenu vertical">
            <label
                class="clock"
                label={now.format("%A, %B %-d") || ""}
            />
            <label
                class="time"
                label={now.format("%-I:%M:%S %p") || ""}
            />
            <Gtk.Calendar visible />
        </box>
    )
}

const DateMenu = () => PopupWindow({
    name: "datemenu",
    exclusivity: "exclusive",
    transition: bar.position.value === "top" ? "slide_down" : "slide_up",
    layout: `${bar.position.value}-${datemenu.position.value}` as "top-center",
    child: DateMenuContent(),
})

export function setupDateMenu() {
    const win = DateMenu()
    globalThis.app?.add_window(win)
}
