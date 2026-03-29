import { SimpleToggleButton } from "../ToggleButton"
import { createBinding } from "ags"
import icons from "lib/icons"

const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const n = Notifd?.get_default?.() ?? null
const dnd = n ? createBinding(n, "dnd") : null

export const DND = () => SimpleToggleButton({
    icon: dnd ? dnd.as((d: boolean) => icons.notifications[d ? "silent" : "noisy"]) : icons.notifications.noisy,
    label: dnd ? dnd.as((d: boolean) => d ? "Silent" : "Noisy") : "Noisy",
    toggle: () => { if (n) n.dnd = !n.dnd },
    connection: n ? [n, () => n.dnd] : [null, () => false],
})
