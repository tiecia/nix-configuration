import options from "options"

const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const { blacklist } = options.notifications

export default function init() {
    const notifd = Notifd?.get_default?.()
    if (!notifd) return
    
    notifd.connect("notified", (_, id: number) => {
        const notif = notifd.get_notification(id)
        if (!notif) return
        
        if (blacklist.value.includes(notif.app_name)) {
            notif.dismiss()
        }
    })
}
