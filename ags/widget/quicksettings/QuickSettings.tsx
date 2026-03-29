import PopupWindow from "widget/PopupWindow"
import options from "options"

const { bar, quicksettings } = options

function QuickSettingsContent() {
    return (
        <box class="quicksettings vertical" css={`min-width: ${quicksettings.width.value}px;`}>
            <label class="title" label="Quick Settings" />
            <box class="row" homogeneous>
                <button onClicked={() => { options.theme.scheme.value = options.theme.scheme.value === "dark" ? "light" : "dark" }}>
                    <label label="Toggle Theme" />
                </button>
                <button onClicked={() => { options.notifications.position.value = ["top", "right"] }}>
                    <label label="Notifications" />
                </button>
            </box>
            <box class="row" homogeneous>
                <button onClicked={() => { options.bar.transparent.value = !options.bar.transparent.value }}>
                    <label label="Bar Transparency" />
                </button>
                <button onClicked={() => { options.bar.corners.value = !options.bar.corners.value }}>
                    <label label="Bar Corners" />
                </button>
            </box>
        </box>
    )
}

const QuickSettings = () => PopupWindow({
    name: "quicksettings",
    exclusivity: "exclusive",
    transition: bar.position.value === "top" ? "slide_down" : "slide_up",
    layout: `${bar.position.value}-${quicksettings.position.value}` as "top-right",
    child: QuickSettingsContent(),
})

export function setupQuickSettings() {
    const win = QuickSettings()
    globalThis.app?.add_window(win)
}
