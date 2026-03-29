import { type IconProps } from "types/widgets/icon"
import type GObject from "gi://GObject?version=2.0"
import Gtk from "gi://Gtk?version=3.0"
import icons from "lib/icons"
import { timeout } from "lib/timer"

// Reactive state tracking which menu sub-panel is open
class OpenedState {
    private _value = ""
    private _nextId = 1
    private _listeners = new Map<number, () => void>()

    get value() { return this._value }
    set value(v: string) {
        if (v === this._value) return
        this._value = v
        for (const cb of this._listeners.values()) cb()
    }

    connect(signal: string, callback: () => void) {
        if (signal !== "changed") return 0
        const id = this._nextId++
        this._listeners.set(id, callback)
        return id
    }

    disconnect(id: number) {
        this._listeners.delete(id)
    }
}

export const opened = new OpenedState()

globalThis.app?.connect("window-toggled", (_: any, name: string, visible: boolean) => {
    if (name === "quicksettings" && !visible)
        timeout(500, () => { opened.value = "" })
})

export const Arrow = (name: string, activate?: false | (() => void)) => {
    let deg = 0
    let iconOpened = false
    let iconRef: any = null

    return (
        <button
            className="arrow"
            onClicked={() => {
                opened.value = opened.value === name ? "" : name
                if (typeof activate === "function")
                    activate()
            }}
        >
            <icon
                icon={icons.ui.arrow.right}
                setup={(self: any) => {
                    iconRef = self
                    opened.connect("changed", () => {
                        if (
                            (opened.value === name && !iconOpened) ||
                            (opened.value !== name && iconOpened)
                        ) {
                            const step = opened.value === name ? 10 : -10
                            iconOpened = !iconOpened
                            for (let i = 0; i < 9; ++i) {
                                timeout(15 * i, () => {
                                    deg += step
                                    iconRef?.setCss(`-gtk-icon-transform: rotate(${deg}deg);`)
                                })
                            }
                        }
                    })
                }}
            />
        </button>
    )
}

type ArrowToggleButtonProps = {
    name: string
    icon: string
    label: string
    activate: () => void
    deactivate: () => void
    activateOnArrow?: boolean
    connection: [GObject.Object | null, (() => boolean) | null]
}
export const ArrowToggleButton = ({
    name,
    icon,
    label,
    activate,
    deactivate,
    activateOnArrow = true,
    connection: [service, condition],
}: ArrowToggleButtonProps) => (
    <box
        className="toggle-button"
        setup={(self: any) => {
            const update = () => self.toggleClassName("active", condition?.() ?? false)
            update()
            if (service) (service as any).connect("notify", update)
        }}
    >
        <button
            hexpand
            onClicked={() => {
                if (condition()) {
                    deactivate()
                    if (opened.value === name)
                        opened.value = ""
                } else {
                    activate()
                }
            }}
        >
            <box hexpand>
                <icon className="icon" icon={icon} />
                <label
                    className="label"
                    maxWidthChars={10}
                    truncate="end"
                    label={label}
                />
            </box>
        </button>
        {Arrow(name, activateOnArrow && activate)}
    </box>
)

type MenuProps = {
    name: string
    icon: string
    title: string
    content: Gtk.Widget[]
}
export const Menu = ({ name, icon, title, content }: MenuProps) => (
    <revealer
        transitionType="slide_down"
        setup={(self: any) => {
            self.revealChild = opened.value === name
            opened.connect("changed", () => {
                self.revealChild = opened.value === name
            })
        }}
    >
        <box className={`menu ${name}`} vertical>
            <box className="title-box">
                <icon className="icon" icon={icon} />
                <label className="title" truncate="end" label={title} />
            </box>
            <Gtk.Separator visible />
            <box vertical className="content vertical">
                {content}
            </box>
        </box>
    </revealer>
)

type SimpleToggleButtonProps = {
    icon: string
    label: string
    toggle: () => void
    connection: [GObject.Object | null, (() => boolean) | null]
}

export const SimpleToggleButton = ({
    icon,
    label,
    toggle,
    connection: [service, condition],
}: SimpleToggleButtonProps) => (
    <button
        onClicked={toggle}
        className="simple-toggle"
        setup={(self: any) => {
            const update = () => self.toggleClassName("active", condition?.() ?? false)
            update()
            if (service) (service as any).connect("notify", update)
        }}
    >
        <box>
            <icon icon={icon} />
            <label maxWidthChars={10} truncate="end" label={label} />
        </box>
    </button>
)
