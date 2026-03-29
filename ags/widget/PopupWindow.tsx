import { type WindowProps } from "types/widgets/window"
import { type RevealerProps } from "types/widgets/revealer"
import { type EventBoxProps } from "types/widgets/eventbox"
import type Gtk from "gi://Gtk?version=3.0"
import { createBinding } from "ags"
import options from "options"

type Transition = RevealerProps["transition"]
type Child = WindowProps["child"]

type PopupWindowProps = Omit<WindowProps, "name"> & {
    name: string
    layout?: keyof ReturnType<typeof Layout>
    transition?: Transition,
}

export const Padding = (name: string, {
    css = "",
    hexpand = true,
    vexpand = true,
}: EventBoxProps = {}) => (
    <button
        hexpand={hexpand}
        vexpand={vexpand}
        can_focus={false}
        onClicked={() => {
            const win = globalThis.app?.get_window(name)
            if (win) win.set_visible(!win.visible)
        }}
    >
        <box css={css} />
    </button>
)

const PopupRevealer = (
    name: string,
    child: Child,
    transition: Transition = "slide_down",
) => (
    <box css="padding: 1px;">
        <revealer
            transitionType={transition}
            transitionDuration={options.transition.value}
            revealChild={true}
        >
            <box class="window-content">
                {child}
            </box>
        </revealer>
    </box>
)

const Layout = (name: string, child: Child, transition?: Transition) => ({
    "center": () => (
        <centerbox>
            {Padding(name)}
            <centerbox vertical>
                {Padding(name)}
                {PopupRevealer(name, child, transition)}
                {Padding(name)}
            </centerbox>
            {Padding(name)}
        </centerbox>
    ),
    "top": () => (
        <centerbox>
            {Padding(name)}
            <box vertical>
                {PopupRevealer(name, child, transition)}
                {Padding(name)}
            </box>
            {Padding(name)}
        </centerbox>
    ),
    "top-right": () => (
        <box>
            {Padding(name)}
            <box hexpand={false} vertical>
                {PopupRevealer(name, child, transition)}
                {Padding(name)}
            </box>
        </box>
    ),
    "top-center": () => (
        <box>
            {Padding(name)}
            <box hexpand={false} vertical>
                {PopupRevealer(name, child, transition)}
                {Padding(name)}
            </box>
            {Padding(name)}
        </box>
    ),
    "top-left": () => (
        <box>
            <box hexpand={false} vertical>
                {PopupRevealer(name, child, transition)}
                {Padding(name)}
            </box>
            {Padding(name)}
        </box>
    ),
    "bottom-left": () => (
        <box>
            <box hexpand={false} vertical>
                {Padding(name)}
                {PopupRevealer(name, child, transition)}
            </box>
            {Padding(name)}
        </box>
    ),
    "bottom-center": () => (
        <box>
            {Padding(name)}
            <box hexpand={false} vertical>
                {Padding(name)}
                {PopupRevealer(name, child, transition)}
            </box>
            {Padding(name)}
        </box>
    ),
    "bottom-right": () => (
        <box>
            {Padding(name)}
            <box hexpand={false} vertical>
                {Padding(name)}
                {PopupRevealer(name, child, transition)}
            </box>
        </box>
    ),
})

export default ({
    name,
    child,
    layout = "center",
    transition,
    exclusivity = "ignore",
    ...props
}: PopupWindowProps) => (
    <window
        name={name}
        visible={false}
        keymode="on-demand"
        exclusivity={exclusivity}
        layer="top"
        anchor={["top", "bottom", "right", "left"]}
        {...props}
    >
        {Layout(name, child, transition)[layout]()}
    </window>
)
