import { createBinding } from "ags"
import BatteryBar from "./buttons/BatteryBar"
import ColorPicker from "./buttons/ColorPicker"
import Date from "./buttons/Date"
import Launcher from "./buttons/Launcher"
import Media from "./buttons/Media"
import PowerMenu from "./buttons/PowerMenu"
import SysTray from "./buttons/SysTray"
import SystemIndicators from "./buttons/SystemIndicators"
import Taskbar from "./buttons/Taskbar"
import Workspaces from "./buttons/Workspaces"
import ScreenRecord from "./buttons/ScreenRecord"
import Messages from "./buttons/Messages"
import options from "options"

const { start, center, end } = options.bar.layout
const { position } = options.bar

export type BarWidget = keyof typeof widget

const widget = {
    battery: BatteryBar,
    colorpicker: ColorPicker,
    date: Date,
    launcher: () => <box />,
    media: Media,
    powermenu: PowerMenu,
    systray: SysTray,
    system: SystemIndicators,
    taskbar: Taskbar,
    workspaces: Workspaces,
    screenrecord: ScreenRecord,
    messages: Messages,
    expander: () => <box expand />,
}

const renderWidget = (name: BarWidget, monitor?: number) => {
    try {
        const fn = widget[name]
        if (!fn) return <box />
        return monitor !== undefined ? fn(monitor) : fn()
    } catch (error) {
        console.warn(`[bar] skipped widget ${name}:`, error)
        return <box />
    }
}

export default (monitor: number) => (
    <window
        monitor={monitor}
        name={`bar${monitor}`}
        exclusivity="exclusive"
        anchor={[position.value || "top", "right", "left"]}
    >
        <centerbox css="min-width: 2px; min-height: 2px;">
            <box hexpand>
                {(start.value || []).map((w: BarWidget) => renderWidget(w, monitor))}
            </box>
            <box>
                {(center.value || []).map((w: BarWidget) => renderWidget(w))}
            </box>
            <box hexpand>
                {(end.value || []).map((w: BarWidget) => renderWidget(w))}
            </box>
        </centerbox>
    </window>
)
