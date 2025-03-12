import { SimpleToggleButton } from "../ToggleButton"
import icons from "lib/icons"

const icon = () => icons.display;
const label = () => "Display";

export const Hyprdock = () => SimpleToggleButton({
    icon: icon(),
    label: label(),
    toggle: () => Utils.exec("hyprdock -g"),
    connection: [null, null],
})
