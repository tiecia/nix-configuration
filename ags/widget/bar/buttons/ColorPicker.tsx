import PanelButton from "../PanelButton"
import colorpicker from "service/colorpicker"
import Gdk from "gi://Gdk?version=3.0"

const css = (color: string) => `
* {
    background-color: ${color};
    color: transparent;
}
*:hover {
    color: white;
    text-shadow: 2px 2px 3px rgba(0,0,0,.8);
}`

export default () => {
    let menu_ref: any = null

    return PanelButton({
        className: "color-picker",
        onClicked: () => colorpicker.pick(),
        onSecondaryClick: (self: any) => {
            if (!menu_ref) {
                menu_ref = <menu className="colorpicker">
                    {colorpicker.colors.map(color => (
                        <menuitem
                            onActivate={() => colorpicker.wlCopy(color)}
                            setup={(self: any) => {
                                const label_child = <label label={color} />
                                self.set_child(label_child)
                            }}
                            css={css(color)}
                        />
                    ))}
                </menu>
            }

            if (colorpicker.colors.length === 0)
                return

            menu_ref.popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
        },
        child: (
            <box>
                <icon icon="color-select-symbolic" />
            </box>
        ),
        setup: (self: any) => {
            const update = () => {
                self.tooltipText = `${colorpicker.colors.length} colors`
                menu_ref = null
            }
            colorpicker.connect("changed", update)
            update()
        },
    })
}
