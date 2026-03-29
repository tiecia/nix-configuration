import { createBinding } from "ags"
import icons from "lib/icons"
import options from "options"
import PanelButton from "../PanelButton"

const Battery = await import("gi://AstalBattery")
    .then(mod => mod.default)
    .catch(() => null)

const battery = Battery?.get_default?.() ?? null
const { bar, percentage, blocks, width, low } = options.bar.battery

const Indicator = () => (
    <icon
        setup={(self: any) => {
            if (!battery) return
            battery.connect("notify", () => {
                self.icon = battery.charging || battery.charged
                    ? icons.battery.charging
                    : battery.icon_name
            })
        }}
    />
)

const PercentLabel = () => (
    <revealer
        transitionType="slide_right"
        clickThrough
        revealChild={createBinding(percentage)}
    >
        <label
            label={battery ? createBinding(battery, "percent").as((p: number) => `${p}%`) : ""}
        />
    </revealer>
)

const LevelBar = () => {
    let level_ref: any = null

    const updateLevelBar = () => {
        if (!battery) return
        if (level_ref) {
            level_ref.value = (battery.percent / 100) * blocks.value
            level_ref.css = `block { min-width: ${width.value / blocks.value}pt; }`
        }
    }

    return (
        <levelbar
            setup={(self: any) => {
                level_ref = self
                battery.connect("notify", updateLevelBar)
                width.connect("changed", updateLevelBar)
                blocks.connect("changed", updateLevelBar)
                bar.connect("changed", () => {
                    self.vpack = bar.value === "whole" ? "fill" : "center"
                    self.hpack = bar.value === "whole" ? "fill" : "center"
                })
                updateLevelBar()
            }}
            barMode="discrete"
            maxValue={createBinding(blocks)}
            visible={createBinding(bar).as((b: string) => b !== "hidden")}
            value={battery ? createBinding(battery, "percent").as((p: number) => (p / 100) * blocks.value) : 0}
        />
    )
}

const WholeButton = () => (
    <overlay vexpand className="whole" passThrough child={<LevelBar />}>
        <box hpack="center" overlayChild>
            <icon
                icon={icons.battery.charging}
                visible={battery ? createBinding(battery, "charging", battery, "charged").as((charging: boolean, charged: boolean) => charging || charged) : false}
            />
            <box hpack="center" vpack="center">
                <PercentLabel />
            </box>
        </box>
    </overlay>
)

const Regular = () => (
    <box className="regular">
        <Indicator />
        <PercentLabel />
        <LevelBar />
    </box>
)

export default () => PanelButton({
    className: "battery-bar",
    hexpand: false,
    onClicked: () => { percentage.value = !percentage.value },
    visible: battery ? createBinding(battery, "available") : false,
    setup: (self: any) => {
        bar.connect("changed", () => {
            self.toggleClassName("bar-hidden", bar.value === "hidden")
        })
        if (!battery) return
        battery.connect("notify", () => {
            self.toggleClassName("charging", battery.charging || battery.charged)
            self.toggleClassName("low", battery.percent < low.value)
        })
    },
    child: (
        <box
            expand
            visible={battery ? createBinding(battery, "available") : false}
        >
            {createBinding(bar).as((b: string) => b === "whole" ? <WholeButton /> : <Regular />)}
        </box>
    ),
})
