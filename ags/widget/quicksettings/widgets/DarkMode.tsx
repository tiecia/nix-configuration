import { SimpleToggleButton } from "../ToggleButton"
import icons from "lib/icons"
import options from "options"

const { scheme } = options.theme

export const DarkModeToggle = () => (
    <button
        className="simple-toggle"
        onClicked={() => { scheme.value = scheme.value === "dark" ? "light" : "dark" }}
        setup={(self: any) => {
            const update = () => self.toggleClassName("active", scheme.value === "dark")
            update()
            scheme.connect("changed", update)
        }}
    >
        <box>
            <icon
                setup={(self: any) => {
                    const u = () => { self.icon = icons.color[scheme.value] }
                    u()
                    scheme.connect("changed", u)
                }}
            />
            <label
                maxWidthChars={10}
                truncate="end"
                setup={(self: any) => {
                    const u = () => { self.label = scheme.value === "dark" ? "Dark" : "Light" }
                    u()
                    scheme.connect("changed", u)
                }}
            />
        </box>
    </button>
)
