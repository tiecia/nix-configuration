import { createBinding } from "ags"
import PopupWindow from "widget/PopupWindow"
import Workspace from "./Workspace"
import options from "options"
import { range } from "lib/utils"
 
const AstalHyprland = await import("gi://AstalHyprland")
    .then(mod => mod.default)
    .catch(() => null)

const hyprland = AstalHyprland?.get_default?.() ?? null

const Overview = (ws: number) => {
    let box_ref: any = null

    return (
        <box
            ref={(ref: any) => { box_ref = ref }}
            className="overview horizontal"
            setup={(self: any) => {
                if (ws <= 0 && hyprland) {
                    // Dynamic workspace mode
                    hyprland.connect("notify::workspaces", () => {
                        if (box_ref) {
                            const children = hyprland.workspaces
                                .map((workspace: any) => Workspace(workspace.id))
                                .sort((a: any, b: any) => a.attribute.id - b.attribute.id)
                            box_ref.children = children
                        }
                    })
                }
            }}
        >
            {ws > 0
                ? range(ws).map(i => <Workspace id={i} />)
                : hyprland
                    ? hyprland.workspaces.map((workspace: any) => <Workspace id={workspace.id} />)
                    : []
            }
        </box>
    )
}

export default () => PopupWindow({
    name: "overview",
    layout: "center",
    child: createBinding(options.overview.workspaces).as((ws: number) => <Overview ws={ws} />),
})
