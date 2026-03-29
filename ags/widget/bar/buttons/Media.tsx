import PanelButton from "../PanelButton"
import options from "options"
import icons from "lib/icons"
const { format } = options.bar.media

export default () => PanelButton({
    className: "media",
    child: (
        <box>
            <icon icon={icons.fallback.audio} />
            <label
                visible={format.value.length > 0}
                label={format.value.replace("{title}", "").replace("{artists}", "")}
            />
        </box>
    ),
})
