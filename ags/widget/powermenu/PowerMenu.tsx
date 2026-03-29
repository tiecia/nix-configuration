import PopupWindow from "widget/PopupWindow"
import powermenu, { type Action } from "service/powermenu"
import icons from "lib/icons"
import options from "options"
import type Gtk from "gi://Gtk?version=3.0"

const { layout, labels } = options.powermenu

const SysButton = (action: Action, label: string) => (
    <button
        onClicked={() => powermenu.action(action)}
    >
        <box vertical class="system-button">
            <icon icon={icons.powermenu[action]} />
            <label label={label} visible={labels.value} />
        </box>
    </button>
)

export default () => PopupWindow({
    name: "powermenu",
    transition: "crossfade",
    child: (
        <box<Gtk.Widget>
            class="powermenu horizontal"
        >
            {layout.value === "box"
                ? (
                    <>
                        <box vertical>
                            <SysButton action="shutdown" label="Shutdown" />
                            <SysButton action="logout" label="Log Out" />
                            <SysButton action="lock" label="Lock" />
                        </box>
                        <box vertical>
                            <SysButton action="reboot" label="Reboot" />
                            <SysButton action="sleep" label="Sleep" />
                        </box>
                    </>
                )
                : (
                    <>
                        <SysButton action="shutdown" label="Shutdown" />
                        <SysButton action="logout" label="Log Out" />
                        <SysButton action="lock" label="Lock" />
                        <SysButton action="reboot" label="Reboot" />
                        <SysButton action="sleep" label="Sleep" />
                    </>
                )}
        </box>
    ),
})
