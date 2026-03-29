import { createBinding } from "ags"
import { sh, range } from "lib/utils"
import PanelButton from "../PanelButton"
import options from "options"

const AstalHyprland = await import("gi://AstalHyprland")
    .then(mod => mod.default)
    .catch(() => null)

const hyprland = AstalHyprland?.get_default?.() ?? null
const { workspaces } = options.bar.workspaces

const dispatch = (arg: string | number) => {
    sh(`hyprctl dispatch workspace ${arg}`)
}

const Workspaces = (ws: number, monitor: number) => {
    const labels = range(ws || 7).map(i => {
        const localNum = i + (monitor * ws)
        
        return (
            <label
                key={localNum}
                vpack="center"
                label={`${localNum}`}
                setup={(self: any) => {
                    if (!hyprland) return
                    hyprland.connect("notify", () => {
                        self.toggleClassName("active", hyprland.active.workspace.id === localNum)
                        const ws_obj = hyprland.get_workspace(localNum)
                        const window_count = ws_obj?.windows?.length || 0
                        self.toggleClassName("occupied", window_count > 0)
                    })
                }}
            />
        )
    })

    return <box>{labels}</box>
}

export default (monitor: number) => PanelButton({
    window: "overview",
    className: "workspaces",
    onScrollUp: () => dispatch("m+1"),
    onScrollDown: () => dispatch("m-1"),
    onClicked: () => {
        const win = globalThis.app?.get_window("overview")
        if (win) win.set_visible(!win.visible)
    },
    child: <Workspaces ws={workspaces.value || 7} monitor={monitor} />,
})
