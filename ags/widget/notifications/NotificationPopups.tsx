import { createBinding } from "ags"
import { timeout, idle } from "lib/timer"
import Notification from "./Notification"
import options from "options"
 
const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const notifd = Notifd?.get_default?.() ?? null
const { transition } = options
const { position } = options.notifications

function Animated(id: number) {
    if (!notifd) return <box />

    let widget_ref: any = null
    let inner_ref: any = null
    let outer_ref: any = null

    const n = notifd.get_notification(id)
    if (!n) return <box />

    const widget = Notification(n)

    const dismiss = () => {
        if (inner_ref) inner_ref.reveal_child = false
        timeout(transition.value, () => {
            if (outer_ref) outer_ref.reveal_child = false
            timeout(transition.value, () => {
                if (widget_ref) widget_ref.destroy()
            })
        })
    }

    return (
        <box
            ref={(ref: any) => { widget_ref = ref }}
            hpack="end"
            setup={(self: any) => {
                (self as any).dismiss = dismiss
                idle(() => {
                    if (outer_ref) outer_ref.reveal_child = true
                    timeout(transition.value, () => {
                        if (inner_ref) inner_ref.reveal_child = true
                    })
                })
            }}
        >
            <revealer
                ref={(ref: any) => { outer_ref = ref }}
                transitionType="slide_down"
                transitionDuration={transition.value}
            >
                <revealer
                    ref={(ref: any) => { inner_ref = ref }}
                    transitionType="slide_left"
                    transitionDuration={transition.value}
                >
                    {widget}
                </revealer>
            </revealer>
        </box>
    )
}

function PopupList() {
    if (!notifd) return <box />

    let box_ref: any = null
    const map = new Map<number, any>()

    const remove = (_: any, id: number) => {
        const widget = map.get(id)
        if (widget?.dismiss) widget.dismiss()
        map.delete(id)
    }

    return (
        <box
            ref={(ref: any) => { box_ref = ref }}
            hpack="end"
            vertical
            css={createBinding(options.notifications.width).as((w: number) => `min-width: ${w}px;`)}
            setup={(self: any) => {
                notifd.connect("notified", (_, id: number) => {
                    if (id !== undefined) {
                        if (map.has(id))
                            remove(null, id)

                        if (notifd.dnd)
                            return

                        const w = Animated(id)
                        map.set(id, w)
                        if (self.children) {
                            self.children = [w, ...(self.children || [])]
                        }
                    }
                })

                notifd.connect("dismissed", (_, id: number) => remove(null, id))
                notifd.connect("closed", (_, id: number) => remove(null, id))
            }}
        />
    )
}

export default (monitor: number) => (
    <window
        monitor={monitor}
        name={`notifications${monitor}`}
        anchor={createBinding(position)}
        className="notifications"
        visible={!!notifd}
    >
        <box css="padding: 2px;">
            <PopupList />
        </box>
    </window>
)
