import { createBinding } from "ags"
import { timeout, idle } from "lib/timer"
import { icon } from "lib/utils"
import icons from "lib/icons"
import Progress from "./Progress"
import brightness from "service/brightness"
import options from "options"

const { progress: progressOpt, microphone: microphoneOpt } = options.osd

const DELAY = 2500

function OnScreenProgress({ vertical }: { vertical: boolean }) {
    let indicator_ref: any = null
    let progress_ref: any = null
    let revealer_ref: any = null

    const show = (value: number, icon_name: string) => {
        if (indicator_ref) indicator_ref.icon = icon_name
        if (progress_ref) progress_ref.setValue(value)
        if (revealer_ref) revealer_ref.reveal_child = true

        let count = 1
        timeout(DELAY, () => {
            count--
            if (count === 0 && revealer_ref)
                revealer_ref.reveal_child = false
        })
    }

    return (
        <revealer
            ref={(ref: any) => { revealer_ref = ref }}
            transitionType="slide_left"
            setup={(self: any) => {
                brightness.connect("changed", () => show(brightness.screen, icons.brightness.screen))
            }}
        >
            <Progress vertical={vertical} width={vertical ? 42 : 300} height={vertical ? 300 : 42}>
                <icon ref={(ref: any) => { indicator_ref = ref }} size={42} vpack="start" />
            </Progress>
        </revealer>
    )
}

function MicrophoneMute() {
    let icon_ref: any = null
    let revealer_ref: any = null
    let mute = false

    return (
        <revealer
            ref={(ref: any) => { revealer_ref = ref }}
            transitionType="slide_up"
            setup={() => {
                void mute
            }}
        >
            <icon ref={(ref: any) => { icon_ref = ref }} className="microphone" />
        </revealer>
    )
}

export default (monitor: number) => (
    <window
        monitor={monitor}
        name={`indicator${monitor}`}
        className="indicator"
        layer="overlay"
        clickThrough
        anchor={["right", "left", "top", "bottom"]}
    >
        <box css="padding: 2px;" expand>
            <overlay expand>
                <box expand />
                <box
                    hpack={createBinding(progressOpt.pack, "h")}
                    vpack={createBinding(progressOpt.pack, "v")}
                >
                    {createBinding(progressOpt, "vertical").as((v: boolean) => <OnScreenProgress vertical={v} />)}
                </box>
                <box
                    hpack={createBinding(microphoneOpt.pack, "h")}
                    vpack={createBinding(microphoneOpt.pack, "v")}
                >
                    <MicrophoneMute />
                </box>
            </overlay>
        </box>
    </window>
)
