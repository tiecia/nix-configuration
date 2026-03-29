import { idle } from "lib/timer"
import icons from "lib/icons"
import Row from "./Row"

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export default (title: string, ...rows: ReturnType<typeof Row<any>>[]) => (
    <box className="group" vertical>
        <box>
            <label
                hpack="start"
                vpack="end"
                className="group-title"
                label={title}
                setup={(self: any) => idle(() => { self.visible = !!title })}
            />
            {title ? (
                <button
                    hexpand
                    hpack="end"
                    className="group-reset"
                    onClicked={() => rows.forEach(row => row.opt.reset())}
                    setup={(self: any) => {
                        const update = () => {
                            self.sensitive = rows.some(row => row.opt.value !== row.opt.initial)
                        }
                        update()
                        rows.forEach(row => row.opt.connect("changed", update))
                    }}
                >
                    <icon icon={icons.ui.refresh} />
                </button>
            ) : (<box />)}
        </box>
        <box vertical>
            {rows}
        </box>
    </box>
)
