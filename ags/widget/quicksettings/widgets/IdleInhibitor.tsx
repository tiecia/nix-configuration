import { SimpleToggleButton } from "../ToggleButton"
import { exec } from "lib/utils"
import icons from "lib/icons"

export const IdleInhibitor = () => {
    const enabled = exec("matcha -g") === "enabled"
    return (
        <button className="simple-toggle" onClicked={() => exec("matcha -t")}>
            <box>
                <icon icon={enabled ? icons.audio.mic.muted : icons.audio.mic.high} />
                <label
                    maxWidthChars={10}
                    truncate="end"
                    label={enabled ? "Idle Inhibited" : "Idle Normal"}
                />
            </box>
        </button>
    )
}
