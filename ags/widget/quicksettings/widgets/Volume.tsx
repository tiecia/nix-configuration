import { type Stream } from "types/service/audio"
import { createBinding } from "ags"
import AstalWp from "gi://AstalWp"
import Gtk from "gi://Gtk?version=3.0"
import { Arrow, Menu } from "../ToggleButton"
import { dependencies, icon as lookupIcon, sh } from "lib/utils"
import icons from "lib/icons.js"

const wp = AstalWp.get_default()!
const audio = wp.audio

const getEndpoint = (type: "speaker" | "microphone") =>
    type === "speaker" ? audio.defaultSpeaker : audio.defaultMicrophone

const VolumeIndicator = (type: "speaker" | "microphone" = "speaker") => {
    const ep = getEndpoint(type)
    return (
        <button
            vpack="center"
            onClicked={() => { ep.mute = !ep.mute }}
        >
            <icon
                tooltipText={createBinding(ep, "volume").as(
                    (v: number) => `Volume: ${Math.floor(v * 100)}%`,
                )}
                setup={(self: any) => {
                    const u = () => {
                        self.icon = lookupIcon(
                            ep.icon || "",
                            icons.audio.mic.high,
                        )
                    }
                    u()
                    ep.connect("notify::icon", u)
                }}
            />
        </button>
    )
}

const VolumeSlider = (type: "speaker" | "microphone" = "speaker") => {
    const ep = getEndpoint(type)
    return (
        <slider
            hexpand
            drawValue={false}
            value={createBinding(ep, "volume")}
            onDragged={({ value }: any) => {
                ep.volume = value
                ep.mute = false
            }}
            setup={(self: any) => {
                const u = () => {
                    self.toggleClassName("muted", ep.mute)
                }
                u()
                ep.connect("notify::mute", u)
            }}
        />
    )
}

export const Volume = () => (
    <box className="volume">
        {VolumeIndicator("speaker")}
        {VolumeSlider("speaker")}
        <box vpack="center">
            {Arrow("sink-selector")}
        </box>
        <box
            vpack="center"
            setup={(self: any) => {
                const u = () => { self.visible = audio.streams.length > 0 }
                u()
                audio.connect("notify::streams", u)
            }}
        >
            {Arrow("app-mixer")}
        </box>
    </box>
)

export const Microphone = () => (
    <box
        className="slider horizontal"
        setup={(self: any) => {
            const u = () => { self.visible = audio.recorders.length > 0 }
            u()
            audio.connect("notify::recorders", u)
        }}
    >
        {VolumeIndicator("microphone")}
        {VolumeSlider("microphone")}
    </box>
)

const MixerItem = (stream: any) => (
    <box hexpand className="mixer-item horizontal">
        <icon
            tooltipText={createBinding(stream, "name").as((n: string) => n || "")}
            setup={(self: any) => {
                const u = () => {
                    const gtk = Gtk.IconTheme.get_default()
                    const n = stream.name || ""
                    self.icon = gtk.has_icon(n) ? n : icons.fallback.audio
                }
                u()
                stream.connect("notify::name", u)
            }}
        />
        <box vertical>
            <label
                xalign={0}
                truncate="end"
                maxWidthChars={28}
                label={createBinding(stream, "description").as((d: string) => d || "")}
            />
            <slider
                hexpand
                drawValue={false}
                value={createBinding(stream, "volume")}
                onDragged={({ value }: any) => { stream.volume = value }}
            />
        </box>
    </box>
)

const SinkItem = (stream: any) => (
    <button
        hexpand
        onClicked={() => {
            // Set this stream as the default speaker via WirePlumber
            ;(stream as any).set_default?.()
        }}
    >
        <box>
            <icon
                icon={lookupIcon(stream.icon || "", icons.fallback.audio)}
                tooltipText={stream.icon || ""}
            />
            <label label={(stream.description || "").split(" ").slice(0, 4).join(" ")} />
            <icon
                icon={icons.ui.tick}
                hexpand
                hpack="end"
                setup={(self: any) => {
                    const u = () => {
                        self.visible =
                            audio.defaultSpeaker?.id === stream.id
                    }
                    u()
                    audio.connect("notify::default-speaker", u)
                }}
            />
        </box>
    </button>
)

const SettingsButton = () => (
    <button
        hexpand
        onClicked={() => {
            if (dependencies("pavucontrol"))
                sh("pavucontrol")
        }}
    >
        <box>
            <icon icon={icons.ui.settings} />
            <label label="Settings" />
        </box>
    </button>
)

export const AppMixer = () => Menu({
    name: "app-mixer",
    icon: icons.audio.mixer,
    title: "App Mixer",
    content: [
        (
            <box
                vertical
                className="vertical mixer-item-box"
                setup={(self: any) => {
                    const u = () => {
                        self.children = audio.streams.map(MixerItem)
                    }
                    u()
                    audio.connect("notify::streams", u)
                }}
            />
        ) as any,
        new Gtk.Separator({ visible: true }),
        SettingsButton() as any,
    ],
})

export const SinkSelector = () => Menu({
    name: "sink-selector",
    icon: icons.audio.type.headset,
    title: "Sink Selector",
    content: [
        (
            <box
                vertical
                setup={(self: any) => {
                    const u = () => {
                        self.children = audio.speakers.map(SinkItem)
                    }
                    u()
                    audio.connect("notify::speakers", u)
                }}
            />
        ) as any,
        new Gtk.Separator({ visible: true }),
        SettingsButton() as any,
    ],
})
