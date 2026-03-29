import GLib from "gi://GLib"
import Gtk from "gi://Gtk?version=3.0"
import icons from "lib/icons"

const fmt = (t: number, format = "%-I:%M %p") =>
    GLib.DateTime.new_from_unix_local(t).format(format)

const NotificationIcon = (notification: any) => {
    const { image, appIcon, appEntry, app_icon, app_entry } = notification
    const img = image

    if (img) {
        return (
            <box
                vpack="start"
                hexpand={false}
                className="icon img"
                css={`
                    background-image: url("${img}");
                    background-size: cover;
                    background-repeat: no-repeat;
                    background-position: center;
                    min-width: 78px;
                    min-height: 78px;
                `}
            />
        )
    }

    const theme = Gtk.IconTheme.get_default()
    let iconName = icons.fallback.notification
    const ico = appIcon ?? app_icon ?? ""
    const entry = appEntry ?? app_entry ?? ""
    if (ico && theme.has_icon(ico)) iconName = ico
    if (entry && theme.has_icon(entry)) iconName = entry

    return (
        <box
            vpack="start"
            hexpand={false}
            className="icon"
            css="min-width: 78px; min-height: 78px;"
        >
            <icon
                icon={iconName}
                size={58}
                hpack="center"
                hexpand
                vpack="center"
                vexpand
            />
        </box>
    )
}

export default (notification: any) => {
    const content = (
        <box className="content">
            {NotificationIcon(notification)}
            <box hexpand vertical>
                <box>
                    <label
                        className="title"
                        xalign={0}
                        justification="left"
                        hexpand
                        maxWidthChars={24}
                        wrap
                        label={notification.summary?.trim() ?? ""}
                        useMarkup
                    />
                    <label
                        className="time"
                        vpack="start"
                        label={fmt(notification.time) ?? ""}
                    />
                    <button
                        className="close-button"
                        vpack="start"
                        onClicked={() => notification.dismiss?.()}
                    >
                        <icon icon="window-close-symbolic" />
                    </button>
                </box>
                <label
                    className="description"
                    hexpand
                    useMarkup
                    xalign={0}
                    justification="left"
                    label={notification.body?.trim() ?? ""}
                    maxWidthChars={24}
                    wrap
                />
            </box>
        </box>
    )

    const actionsbox = notification.actions?.length > 0
        ? (
            <revealer transitionType="slide_down">
                <eventbox>
                    <box className="actions horizontal">
                        {notification.actions.map((action: any) => (
                            <button
                                className="action-button"
                                onClicked={() => notification.invokeAction?.(action.id) ?? notification.invoke?.(action.id)}
                                hexpand
                            >
                                <label label={action.label} />
                            </button>
                        ))}
                    </box>
                </eventbox>
            </revealer>
        ) as any
        : null

    const eventbox = (
        <eventbox
            vexpand={false}
            onPrimaryClick={() => notification.dismiss?.()}
            onHover={() => {
                if (actionsbox) actionsbox.revealChild = true
            }}
            onHoverLost={() => {
                if (actionsbox) actionsbox.revealChild = true
                notification.dismiss?.()
            }}
        >
            <box vertical>
                {content}
                {actionsbox}
            </box>
        </eventbox>
    )

    return (
        <box className={`notification ${notification.urgency ?? ""}`}>
            {eventbox}
        </box>
    )
}
