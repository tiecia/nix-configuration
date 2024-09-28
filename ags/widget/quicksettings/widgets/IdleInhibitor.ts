import { SimpleToggleButton } from "../ToggleButton"
import icons from "lib/icons"

const icon = () => Utils.exec("matcha -g") === "enabled"
    ? icons.audio.mic.muted
    : icons.audio.mic.high

const label = () => Utils.exec("matcha -g") === "enabled"
    ? "Idle Inhibited"
    : "Idle Normal"

export const IdleInhibitor = () => SimpleToggleButton({
    icon: icon(),
    label: label(),
    toggle: () => Utils.exec("matcha -t"),
    connection: () => [null, null],
})
