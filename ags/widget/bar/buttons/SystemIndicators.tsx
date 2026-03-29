import { createBinding } from "ags"
import PanelButton from "../PanelButton"
import icons from "lib/icons"
 
const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const DNDIndicator = () => {
    const notifd = Notifd?.get_default?.()
    if (!notifd) return <box />
    return (
        <icon
            visible={createBinding(notifd, "dnd")}
            icon={icons.notifications.silent}
        />
    )
}

const BluetoothIndicator = () => {
    // Placeholder - would need AstalBluetooth service
    return <box />
}

const NetworkIndicator = () => {
    // Placeholder - would need AstalNetwork service
    return <box />
}

const AudioIndicator = () => {
    // Placeholder - would need AstalWirePlumber service
    return <box />
}

const MicrophoneIndicator = () => {
    // Placeholder - would need AstalWirePlumber service
    return <box />
}

export default () => PanelButton({
    window: "quicksettings",
    onClicked: () => {
        const win = globalThis.app?.get_window("quicksettings")
        if (win) win.set_visible(!win.visible)
    },
    onScrollUp: () => {
        // Would need audio service: audio.speaker.volume += 0.02
    },
    onScrollDown: () => {
        // Would need audio service: audio.speaker.volume -= 0.02
    },
    child: (
        <box>
            <DNDIndicator />
            <BluetoothIndicator />
            <NetworkIndicator />
            <AudioIndicator />
            <MicrophoneIndicator />
        </box>
    ),
})
