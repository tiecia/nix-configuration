import PopupWindow from "widget/PopupWindow"
import options from "options"

export default () => PopupWindow({
    name: "settings",
    layout: "center",
    child: (
        <box class="settings-dialog" vertical>
            <label class="title" label="Settings" />
            <box class="row" homogeneous>
                <button onClicked={() => { options.theme.scheme.value = "dark" }}>
                    <label label="Dark" />
                </button>
                <button onClicked={() => { options.theme.scheme.value = "light" }}>
                    <label label="Light" />
                </button>
            </box>
            <box class="row" homogeneous>
                <button onClicked={() => { options.bar.position.value = "top" }}>
                    <label label="Bar Top" />
                </button>
                <button onClicked={() => { options.bar.position.value = "bottom" }}>
                    <label label="Bar Bottom" />
                </button>
            </box>
        </box>
    ),
})
