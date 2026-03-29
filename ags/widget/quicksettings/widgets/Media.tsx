import { type MprisPlayer } from "types/service/mpris"
import { createBinding } from "ags"
import AstalMpris from "gi://AstalMpris"
import icons from "lib/icons"
import options from "options"
import { icon as lookupIcon } from "lib/utils"
import { interval } from "lib/timer"

const mpris = AstalMpris.get_default()
const { media } = options.quicksettings

function lengthStr(length: number) {
    const min = Math.floor(length / 60)
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}

const Player = (player: any) => {
    const cover = (
        <box
            className="cover"
            vpack="start"
            setup={(self: any) => {
                const update = () => {
                    const path = player.coverArt || player.coverPath || player.trackCoverUrl || ""
                    const size = media.coverSize.value
                    self.css = `
                        min-width: ${size}px;
                        min-height: ${size}px;
                        background-image: url('${path}');
                    `
                }
                update()
                player.connect("notify", update)
                media.coverSize.connect("changed", update)
            }}
        />
    )

    const title = (
        <label
            className="title"
            maxWidthChars={20}
            truncate="end"
            hpack="start"
            label={createBinding(player, "title")}
        />
    )

    const artist = (
        <label
            className="artist"
            maxWidthChars={20}
            truncate="end"
            hpack="start"
            label={createBinding(player, "artist")}
        />
    )

    const positionSlider = (
        <slider
            className="position"
            drawValue={false}
            onDragged={({ value }: any) => { player.position = value * player.length }}
            setup={(self: any) => {
                const update = () => {
                    const { length, position } = player
                    self.visible = length > 0
                    self.value = length > 0 ? position / length : 0
                }
                player.connect("notify", update)
                interval(1000, update)
                update()
            }}
        />
    )

    const positionLabel = (
        <label
            className="position"
            hpack="start"
            setup={(self: any) => {
                const update = () => {
                    self.label = lengthStr(player.position)
                    self.visible = player.length > 0
                }
                player.connect("notify::position", update)
                interval(1000, update)
                update()
            }}
        />
    )

    const lengthLabel = (
        <label
            className="length"
            hpack="end"
            setup={(self: any) => {
                const u = () => {
                    self.visible = player.length > 0
                    self.label = lengthStr(player.length)
                }
                u()
                player.connect("notify::length", u)
            }}
        />
    )

    const playerIcon = (
        <icon
            className="icon"
            hexpand
            hpack="end"
            vpack="start"
            tooltipText={player.identity || ""}
            setup={(self: any) => {
                const update = () => {
                    const name = `${player.entry}${media.monochromeIcon.value ? "-symbolic" : ""}`
                    self.icon = lookupIcon(name, icons.fallback.audio)
                }
                update()
                player.connect("notify::entry", update)
                media.monochromeIcon.connect("changed", update)
            }}
        />
    )

    const playPause = (
        <button
            className="play-pause"
            onClicked={() => player.playPause()}
            setup={(self: any) => {
                const u = () => { self.visible = player.canPlay }
                u()
                player.connect("notify::can-play", u)
            }}
        >
            <icon
                setup={(self: any) => {
                    const u = () => {
                        self.icon = player.playbackStatus === "Playing"
                            ? icons.mpris.playing
                            : icons.mpris.stopped
                    }
                    u()
                    player.connect("notify::playback-status", u)
                }}
            />
        </button>
    )

    const prev = (
        <button
            onClicked={() => player.previous()}
            setup={(self: any) => {
                const u = () => { self.visible = player.canGoPrevious }
                u()
                player.connect("notify::can-go-previous", u)
            }}
        >
            <icon icon={icons.mpris.prev} />
        </button>
    )

    const next = (
        <button
            onClicked={() => player.next()}
            setup={(self: any) => {
                const u = () => { self.visible = player.canGoNext }
                u()
                player.connect("notify::can-go-next", u)
            }}
        >
            <icon icon={icons.mpris.next} />
        </button>
    )

    return (
        <box className="player" vexpand={false}>
            {cover}
            <box vertical>
                <box>
                    {title}
                    {playerIcon}
                </box>
                {artist}
                <box vexpand />
                {positionSlider}
                <centerbox className="footer horizontal">
                    <box $type="start">{positionLabel}</box>
                    <box $type="center">
                        {prev}
                        {playPause}
                        {next}
                    </box>
                    <box $type="end">{lengthLabel}</box>
                </centerbox>
            </box>
        </box>
    )
}

export const Media = () => (
    <box
        vertical
        className="media vertical"
        setup={(self: any) => {
            const update = () => {
                self.children = mpris.players.map(Player)
            }
            update()
            mpris.connect("notify::players", update)
        }}
    />
)
