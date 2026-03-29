import Notification from "widget/notifications/Notification"
import options from "options"
import icons from "lib/icons"
import { timeout } from "lib/timer"

const AstalNotifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const notifd = AstalNotifd?.get_default?.() ?? null

const Animated = (n: any) => {
    const dur = options.transition.value
    const w = (
        <revealer transitionDuration={dur} transitionType="slide_down">
            {Notification(n)}
        </revealer>
    ) as any
    timeout(dur, () => {
        if (!w.is_destroyed) w.revealChild = true
    })
    return w
}

const ClearButton = () => (
    <button
        visible={!!notifd}
        onClicked={() => notifd.get_notifications?.().forEach((n: any) => n.dismiss?.())}
        setup={(self: any) => {
            if (!notifd) return
            const update = () => {
                const count = notifd.get_notifications?.().length ?? 0
                self.sensitive = count > 0
            }
            update()
            notifd.connect("notify", update)
        }}
    >
        <box>
            <label label="Clear " />
            <icon
                setup={(self: any) => {
                    if (!notifd) return
                    const update = () => {
                        const count = notifd.get_notifications?.().length ?? 0
                        self.icon = icons.trash[count > 0 ? "full" : "empty"]
                    }
                    update()
                    notifd.connect("notify", update)
                }}
            />
        </box>
    </button>
)

const Header = () => (
    <box className="header">
        <label label="Notifications" hexpand xalign={0} />
        <ClearButton />
    </box>
)

const NotificationList = () => {
    if (!notifd) return <box vertical /> as any

    const map = new Map<number, any>()

    const box = (<box vertical />) as any

    function updateVisibility() {
        box.visible = (notifd.get_notifications?.().length ?? 0) > 0
    }

    function remove(id: number) {
        const w = map.get(id)
        if (w) {
            w.revealChild = false
            timeout(options.transition.value, () => {
                w.destroy?.()
                map.delete(id)
            })
        }
    }

    // Build initial list
    ;(notifd.get_notifications?.() ?? []).forEach((n: any) => {
        const w = Animated(n)
        map.set(n.id, w)
        box.children = [...(box.children ?? []), w]
    })
    updateVisibility()

    notifd.connect("notified", (_: any, id: number) => {
        if (map.has(id)) remove(id)
        const n = notifd.get_notification?.(id)
        if (n) {
            const w = Animated(n)
            map.set(id, w)
            box.children = [w, ...(box.children ?? [])]
        }
        updateVisibility()
    })

    notifd.connect("resolved", (_: any, id: number) => {
        remove(id)
        updateVisibility()
    })

    return box
}

const Placeholder = () => (
    <box
        className="placeholder"
        vertical
        vpack="center"
        hpack="center"
        vexpand
        hexpand
        setup={(self: any) => {
            if (!notifd) {
                self.visible = true
                return
            }
            const update = () => {
                self.visible = (notifd.get_notifications?.().length ?? 0) === 0
            }
            update()
            notifd.connect("notify", update)
        }}
    >
        <icon icon={icons.notifications.silent} />
        <label label="Your inbox is empty" />
    </box>
)

export default () => (
    <box
        className="notifications"
        vertical
        setup={(self: any) => {
            const update = () => {
                self.css = `min-width: ${options.notifications.width.value}px`
            }
            update()
            options.notifications.width.connect("changed", update)
        }}
    >
        <Header />
        <scrollable
            vexpand
            hscroll="never"
            className="notification-scrollable"
        >
            <box className="notification-list vertical" vertical>
                {NotificationList()}
                <Placeholder />
            </box>
        </scrollable>
    </box>
)
