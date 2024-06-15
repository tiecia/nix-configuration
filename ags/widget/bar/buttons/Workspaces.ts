import PanelButton from "../PanelButton"
import options from "options"
import { sh, range } from "lib/utils"

const hyprland = await Service.import("hyprland")
const { workspaces } = options.bar.workspaces

const dispatch = (arg: string | number) => {
    sh(`hyprctl dispatch workspace ${arg}`)
}

const Workspaces = (ws: number, monitor: number) => Widget.Box({
    children: range(ws || 7).map(i => Widget.Label({
        attribute: i*(monitor+1),
        vpack: "center",
        label: `${i*(monitor+1)}`,
        setup: self => self.hook(hyprland, () => {
            self.toggleClassName("active", hyprland.active.workspace.id === i*(monitor+1))
            self.toggleClassName("occupied", (hyprland.getWorkspace(i*(monitor+1))?.windows || 0) > 0)
        }),
    })),
    setup: box => {
        print("Creating workspace widget with num workspaces: " + ws);
        print("Monitor: " + monitor);
        if (ws === 0) {
            box.hook(hyprland.active.workspace, () => box.children.map(btn => {
                btn.visible = hyprland.workspaces.some(ws => ws.id === btn.attribute)
            }))
        }
    },
})

export default (monitor: number) => PanelButton({
    window: "overview",
    class_name: "workspaces",
    on_scroll_up: () => dispatch("m+1"),
    on_scroll_down: () => dispatch("m-1"),
    on_clicked: () => App.toggleWindow("overview"),
    child: Workspaces(workspaces.getValue(), monitor),
})
