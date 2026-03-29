import PanelButton from "../PanelButton"
import screenrecord from "service/screenrecord"
import icons from "lib/icons"

export default () => PanelButton({
    className: "recorder",
    onClicked: () => screenrecord.stop(),
    visible: false,
    setup: (self: any) => {
        const update = () => {
            self.visible = Boolean(screenrecord.recording)
            const [box] = self.get_children?.() || []
            const labels = box?.get_children?.().filter((c: any) => c.constructor.name.includes("Label")) || []
            if (labels[0]) {
                const time = screenrecord.timer
                const sec = time % 60
                const min = Math.floor(time / 60)
                labels[0].label = `${min}:${sec < 10 ? "0" + sec : sec}`
            }
        }
        screenrecord.connect("changed", update)
        update()
    },
    child: (
        <box>
            <icon icon={icons.recorder.recording} />
            <label label="0:00" />
        </box>
    ),
})
