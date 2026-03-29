import AstalMpris from "gi://AstalMpris"
import { createBinding } from "ags"
import { timeout } from "lib/timer"
import options from "options"
import { matugen } from "lib/matugen"

const mpris = AstalMpris.get_default()

const pref = () => options.bar.media.preferred.value

export default (monitor: number) => (
    <window
        monitor={monitor}
        layer="bottom"
        name={`desktop${monitor}`}
        className="desktop"
        anchor={["top", "bottom", "left", "right"]}
    >
        <box
            expand
            css={createBinding(options.theme.dark.primary.bg).as((c: string) => `
                transition: 500ms;
                background-color: ${c}`)}
        >
            <box
                className="wallpaper"
                expand
                vpack="center"
                hpack="center"
                setup={(self: any) => {
                    mpris.connect("notify::players", () => {
                        const player = mpris.players.find((p: any) => p.identity === pref())
                        if (!player) return

                        const img = player.coverArt
                        matugen("image", img)
                        timeout(500, () => {
                            self.css = `
                                background-image: url('${img}');
                                background-size: contain;
                                background-repeat: no-repeat;
                                transition: 200ms;
                                min-width: 700px;
                                min-height: 700px;
                                border-radius: 30px;
                                box-shadow: 25px 25px 30px 0 rgba(0,0,0,0.5);`
                        })
                    })
                }}
            />
        </box>
    </window>
)
