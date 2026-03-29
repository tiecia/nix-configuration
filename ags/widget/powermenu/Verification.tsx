import PopupWindow from "widget/PopupWindow"
import powermenu from "service/powermenu"

export default () => PopupWindow({
    name: "verification",
    transition: "crossfade",
    child: (
        <box class="verification" vertical>
            <box class="text-box" vertical>
                <label
                    class="title"
                    label={powermenu.title}
                />
                <label class="desc" label="Are you sure?" />
            </box>
            <box
                class="buttons horizontal"
                vexpand
                vpack="end"
                homogeneous
            >
                <button onClicked={() => powermenu.execute()}>
                    <label label="Yes" />
                </button>
                <button
                    onClicked={() => {
                        const win = globalThis.app?.get_window("verification")
                        if (win) win.set_visible(false)
                    }}
                >
                    <label label="No" />
                </button>
            </box>
        </box>
    ),
})
