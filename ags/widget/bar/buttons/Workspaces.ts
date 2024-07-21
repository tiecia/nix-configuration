import PanelButton from "../PanelButton"
import options from "options"
import { sh, range } from "lib/utils"

const hyprland = await Service.import("hyprland")
const { workspaces } = options.bar.workspaces

const dispatch = (arg: string | number) => {
    sh(`hyprctl dispatch workspace ${arg}`)
}

const Workspaces = (ws: number, monitor: number) => Widget.Box({
    children: range(ws || 7).map(i => {
        let localNum = i+(monitor*ws);
        // print(localNum);
        // print(hyprland.active.workspace.id);
        return Widget.Label({
            attribute: localNum,
            vpack: "center",
            label: `${localNum}`,
            setup: self => self.hook(hyprland, () => {
                self.toggleClassName("active", hyprland.active.workspace.id === localNum)
                self.toggleClassName("occupied", (hyprland.getWorkspace(localNum)?.windows || 0) > 0)
            }),
        })
    }),
    
    // children: range(ws).map(i => {
    //     let workspaceId = i+(monitor*ws);
    //     for (let workspace in hyprland.workspaces) {
    //       if(workspace.monitorID === monitor + 1 && workspace.id === workspaceId) {
    //         return Widget.Label({
    //             attribute: workspaceId,
    //             vpack: "center",
    //             label: `${workspaceId}`,
    //             setup: self => self.hook(hyprland, () => {
    //                 self.toggleClassName("active", hyprland.active.workspace.id === workspaceId)
    //                 self.toggleClassName("occupied", (hyprland.getWorkspace(workspaceId)?.windows || 0) > 0)
    //             }),
    //         })
    //       }
    //     }
    //     return Widget.Label({
    //         attribute: workspaceId,
    //         vpack: "center",
    //         label: `${workspaceId}`,
    //         setup: self => self.hook(hyprland, () => {
    //             self.toggleClassName("active", hyprland.active.workspace.id === workspaceId)
    //             self.toggleClassName("occupied", (hyprland.getWorkspace(workspaceId)?.windows || 0) > 0)
    //         }),
    //     })
    // }),

    // children: hyprland.workspaces.map(workspace => {
    //   print(JSON.stringify(workspace, null, 4));
    //   let startId = monitor*ws;
    //   let endId = startId+ws;
    //
    //   let workspaceId = workspace.id;
    //   if(workspace.monitorID === monitor + 1) {
    //     return Widget.Label({
    //         attribute: workspaceId,
    //         vpack: "center",
    //         label: `${workspaceId}`,
    //         setup: self => self.hook(hyprland, () => {
    //             self.toggleClassName("active", hyprland.active.workspace.id === workspaceId)
    //             self.toggleClassName("occupied", (workspace.windows || 0) > 0)
    //         }),
    //     });
    //   }
    // }).sort((a, b) => a.attribute - b.attribute),

    // setup: box => {
        // let workspaces = hyprland.workspaces;
        // print("Monitor: " + monitor)
        // print(JSON.stringify(workspaces, null, 4));
        // let children = [];
        // hyprland.workspaces.forEach(workspace => {
        //   if(workspace.monitorID == monitor+1) {
        //     children.push(Widget.Label({
        //       attribute: workspace.id,
        //       vpack: "center",
        //       label: `${workspace.id}`,
        //       setup: self => self.hook(hyprland, () => {
        //           self.toggleClassName("active", hyprland.active.workspace.id === workspace.id)
        //           self.toggleClassName("occupied", (hyprland.getWorkspace(workspace.id)?.windows || 0) > 0)
        //       }),
        //     }));
        //   }
        // });
    //
    //     let startId = monitor*ws;
    //     let endId = startId+ws;
    //     print("Start: " + startId)
    //     print("End: " + endId)
    //     children.sort((a, b) => a.attribute - b.attribute);
    //     for(let i = startId; i<endId; i++) {
    //       print("Checking: " + i);
    //       print("Actual: " + children[i-startId].attribute);
    //       if(children[i-startId].attribute != i) {
    //         print("Adding: " + i)
    //         children.splice(i-startId, 0, Widget.Label({
    //           attribute: i,
    //           vpack: "center",
    //           label: `${i}`,
    //           setup: self => self.hook(hyprland, () => {
    //               self.toggleClassName("active", hyprland.active.workspace.id === i)
    //               self.toggleClassName("occupied", (hyprland.getWorkspace(i)?.windows || 0) > 0)
    //           }),
    //         }));
    //       }
    //     }
    //     box.children = children;
    //     
    //     if (ws === 0) {
    //         box.hook(hyprland.active.workspace, () => box.children.map(btn => {
    //             btn.visible = hyprland.workspaces.some(ws => ws.id === btn.attribute)
    //         }))
    //     }
    //
    // },
})

export default (monitor: number) => PanelButton({
    window: "overview",
    class_name: "workspaces",
    on_scroll_up: () => dispatch("m+1"),
    on_scroll_down: () => dispatch("m-1"),
    on_clicked: () => App.toggleWindow(`overview`),
    child: Workspaces(workspaces.getValue(), monitor),
})
