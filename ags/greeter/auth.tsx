import GLib from "gi://GLib?version=2.0"
import icons from "lib/icons"
import { bash } from "lib/utils"
import { onCleanup } from "ags"
import Gtk from "gi://Gtk?version=3.0"
import Greet from "gi://AstalGreet"

const userName = await bash("find /home -maxdepth 1 -printf '%f\n' | tail -n 1")
const iconFile = `/var/lib/AccountsService/icons/${userName}`

const CMD = GLib.getenv("ASZTAL_DM_CMD") || "Hyprland"
const ENV = GLib.getenv("ASZTAL_DM_ENV")
    || "WLR_NO_HARDWARE_CURSORS=1 _JAVA_AWT_WM_NONREPARENTING=1"

// Module-level password entry ref so greeter.ts can focus it
let _passwordEntry: any = null

export function focusPassword() {
    _passwordEntry?.grab_focus()
}

export default function Auth() {
    let loggingIn = false
    let spinnerRef: any = null
    let lockIconRef: any = null
    let responseRef: any = null
    let revealerRef: any = null

    async function login(text: string) {
        loggingIn = true
        if (spinnerRef) spinnerRef.visible = true
        if (lockIconRef) lockIconRef.visible = false
        if (_passwordEntry) _passwordEntry.text = ""

        try {
            const greet = (Greet as any).get_default()
            await greet.login(userName, text, CMD, ENV.split(/\s+/))
        } catch (res: any) {
            loggingIn = false
            if (spinnerRef) spinnerRef.visible = false
            if (lockIconRef) lockIconRef.visible = true
            if (responseRef) responseRef.label = res?.description || JSON.stringify(res)
            if (revealerRef) revealerRef.reveal_child = true
        }
    }

    return (
        <box className="auth" vertical>
            <overlay>
                <box css="min-width: 200px; min-height: 200px;" vertical>
                    <box className="wallpaper" css={`background-image: url('${WALLPAPER}')`} />
                    <box className="wallpaper-contrast" vexpand />
                </box>
                <box vpack="end" vertical>
                    <box className="avatar" hpack="center"
                        css={`background-image: url('${iconFile}')`} />
                    <box hpack="center">
                        <icon icon={icons.ui.avatar} />
                        <label label={userName} />
                    </box>
                    <box className="password">
                        <Gtk.Spinner
                            ref={(ref: any) => { spinnerRef = ref }}
                            visible={false}
                            active
                        />
                        <icon
                            icon={icons.ui.lock}
                            ref={(ref: any) => { lockIconRef = ref }}
                        />
                        <entry
                            placeholderText="Password"
                            hexpand
                            visibility={false}
                            ref={(ref: any) => {
                                _passwordEntry = ref
                            }}
                            onActivate={({ text }: any) => login(text || "")}
                        />
                    </box>
                </box>
            </overlay>
            <box className="response-box">
                <revealer
                    transitionType="slide_down"
                    ref={(ref: any) => { revealerRef = ref }}
                >
                    <label
                        className="response"
                        wrap
                        maxWidthChars={35}
                        hpack="center"
                        hexpand
                        xalign={0.5}
                        ref={(ref: any) => { responseRef = ref }}
                    />
                </revealer>
            </box>
        </box>
    )
}
