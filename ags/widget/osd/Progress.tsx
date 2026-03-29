import GLib from "gi://GLib?version=2.0"
import { range } from "lib/utils"
import { timeout } from "lib/timer"
import options from "options"

type ProgressProps = {
    height?: number
    width?: number
    vertical?: boolean
    child: any
}

export default ({
    height = 18,
    width = 180,
    vertical = false,
    child,
}: ProgressProps) => {
    const fill = (
        <box
            className="fill"
            hexpand={vertical}
            vexpand={!vertical}
            hpack={vertical ? "fill" : "start"}
            vpack={vertical ? "end" : "fill"}
        >
            {child}
        </box>
    ) as any

    const container = (
        <box
            className="progress"
            css={`min-width: ${width}px; min-height: ${height}px;`}
        >
            {fill}
        </box>
    ) as any

    let fill_size = 0
    let animations: number[] = []

    return Object.assign(container, {
        setValue(value: number) {
            if (value < 0)
                return

            if (animations.length > 0) {
                for (const id of animations)
                    GLib.source_remove(id)
                animations = []
            }

            const axis = vertical ? "height" : "width"
            const axisv = vertical ? height : width
            const min = vertical ? width : height
            const preferred = (axisv - min) * value + min

            if (!fill_size) {
                fill_size = preferred
                fill.css = `min-${axis}: ${preferred}px;`
                return
            }

            const frames = options.transition.value / 10
            const goal = preferred - fill_size
            const step = goal / frames

            animations = range(frames, 0).map(i => timeout(5 * i, () => {
                fill_size += step
                fill.css = `min-${axis}: ${fill_size}px`
                animations.shift()
            }))
        },
    })
}
