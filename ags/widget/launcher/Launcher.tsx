import { createBinding } from "ags"
import PopupWindow from "widget/PopupWindow"
import options from "options"
import { sh } from "lib/utils"

const { width, margin } = options.launcher

export default () => PopupWindow({
    name: "launcher",
    layout: "top",
    child: (
        <box
            vertical
            className="launcher"
            css={createBinding(width, margin).as((w, m) => `min-width: ${w}pt; margin-top: ${m}pt;`)}
        >
            <entry
                hexpand
                placeholderText="Run command or app name"
                onActivate={(self: any) => {
                    const text = (self.text || "").trim()
                    if (!text) return

                    if (text.startsWith(":sh ")) {
                        void sh(text.slice(4))
                    } else {
                        // Keep behavior simple during migration: try desktop launcher first.
                        void sh(`gtk-launch ${text}`).catch(() => sh(text))
                    }

                    self.text = ""
                    const win = globalThis.app?.get_window("launcher")
                    if (win) win.set_visible(false)
                }}
            />
        </box>
    ),
})
