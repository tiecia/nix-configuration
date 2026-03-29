import { createBinding } from "ags"
import icons from "lib/icons"
import PanelButton from "../PanelButton"
import options from "options"
 
const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const n = Notifd?.get_default?.() ?? null
const notifs = n
    ? createBinding(n, "notifications").as((notifications) => notifications?.length || 0)
    : null
export default () => PanelButton({
    className: "messages",
    onClicked: () => options.bar.messages.action.value(),
    visible: notifs ? notifs.as(count => count > 0) : false,
    child: (
        <box>
            <icon icon={icons.notifications.message} />
        </box>
    ),
})
