import { Opt } from "lib/option"
import Setter from "./Setter"
import icons from "lib/icons"

export type RowProps<T> = {
    opt: Opt<T>
    title: string
    note?: string
    type?:
    | "number"
    | "color"
    | "float"
    | "object"
    | "string"
    | "enum"
    | "boolean"
    | "img"
    | "font"
    enums?: string[]
    max?: number
    min?: number
}

export default <T>(props: RowProps<T>) => {
    const w = (
        <box
            className="row"
            tooltipText={props.note ? `note: ${props.note}` : ""}
        >
            <box vertical vpack="center">
                <label xalign={0} className="row-title" label={props.title} />
                <label xalign={0} className="id" label={props.opt.id} />
            </box>
            <box hexpand />
            <box vpack="center">
                {Setter(props) as any}
            </box>
            <button
                vpack="center"
                className="reset"
                onClicked={() => props.opt.reset()}
                setup={(self: any) => {
                    const update = () => {
                        self.sensitive = props.opt.value !== props.opt.initial
                    }
                    update()
                    props.opt.connect("changed", update)
                }}
            >
                <icon icon={icons.ui.refresh} />
            </button>
        </box>
    ) as any
    return Object.assign(w, { opt: props.opt })
}
