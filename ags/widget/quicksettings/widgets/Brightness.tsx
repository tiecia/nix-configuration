import icons from "lib/icons"
import { createBinding } from "ags"
import options from "options"
import brightness from "service/brightness"

const { showBrightness } = options.quicksettings

const BrightnessSlider = () => (
    <slider
        drawValue={false}
        hexpand
        value={createBinding(brightness, "screen")}
        onDragged={({ value }: any) => { brightness.screen = value }}
    />
)

export const Brightness = () => showBrightness.value ? (
    <box className="brightness">
        <button
            vpack="center"
            onClicked={() => { brightness.screen = 0 }}
            tooltipText={createBinding(brightness, "screen").as(
                (v: number) => `Screen Brightness: ${Math.floor(v * 100)}%`,
            )}
        >
            <icon icon={icons.brightness.indicator} />
        </button>
        {BrightnessSlider()}
    </box>
) : null
