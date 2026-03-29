import { SimpleToggleButton } from "../ToggleButton"
import { exec } from "lib/utils"
import icons from "lib/icons"

export const Hyprdock = () => (
    <button className="simple-toggle" onClicked={() => exec("hyprdock -g")}>
        <box>
            <icon icon={icons.display} />
            <label maxWidthChars={10} truncate="end" label="Display" />
        </box>
    </button>
)
