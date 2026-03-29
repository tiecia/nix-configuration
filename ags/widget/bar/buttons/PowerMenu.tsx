import { createBinding } from "ags"
import icons from "lib/icons"
import PanelButton from "../PanelButton"
import options from "options"

const { monochrome, action } = options.bar.powermenu

export default () => PanelButton({
    window: "powermenu",
    onClicked: () => action.value(),
    setup: (self) => {
        self.toggleClassName("colored", !monochrome.value)
        self.toggleClassName("box")
        
        if (monochrome.connect) {
            monochrome.connect("changed", () => {
                self.toggleClassName("colored", !monochrome.value)
            })
        }
    },
    child: (
        <icon icon={icons.powermenu.shutdown} />
    ),
})
