import { SimpleToggleButton } from "../ToggleButton"
import AstalWp from "gi://AstalWp"
import icons from "lib/icons"

const wp = AstalWp.get_default()
const microphone = wp?.audio?.defaultMicrophone

export const MicMute = () => {
    if (!microphone)
        return <box />

    return (
        <button
            className="simple-toggle"
            onClicked={() => { microphone.mute = !microphone.mute }}
            setup={(self: any) => {
                const update = () => self.toggleClassName("active", microphone.mute)
                update()
                microphone.connect("notify::mute", update)
            }}
        >
            <box>
                <icon
                    setup={(self: any) => {
                        const u = () => {
                            self.icon = microphone.mute
                                ? icons.audio.mic.muted
                                : icons.audio.mic.high
                        }
                        u()
                        microphone.connect("notify::mute", u)
                    }}
                />
                <label
                    maxWidthChars={10}
                    truncate="end"
                    setup={(self: any) => {
                        const u = () => {
                            self.label = microphone.mute ? "Muted" : "Unmuted"
                        }
                        u()
                        microphone.connect("notify::mute", u)
                    }}
                />
            </box>
        </button>
    )
}
