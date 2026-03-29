import { type RowProps } from "./Row"
import { Opt } from "lib/option"
import icons from "lib/icons"
import Gtk from "gi://Gtk?version=3.0"
import Gdk from "gi://Gdk?version=3.0"

function EnumSetter(opt: Opt<string>, values: string[]) {
    const lbl = (
        <label
            setup={(self: any) => {
                const update = () => { self.label = `${opt.value}` }
                update()
                opt.connect("changed", update)
            }}
        />
    ) as any

    const step = (dir: 1 | -1) => {
        const i = values.findIndex(i => i === lbl.label)
        opt.setValue(dir > 0
            ? i + dir > values.length - 1 ? values[0] : values[i + dir]
            : i + dir < 0 ? values[values.length - 1] : values[i + dir],
        )
    }

    return (
        <box className="enum-setter">
            {lbl}
            <button onClicked={() => step(-1)}>
                <icon icon={icons.ui.arrow.left} />
            </button>
            <button onClicked={() => step(+1)}>
                <icon icon={icons.ui.arrow.right} />
            </button>
        </box>
    )
}

export default function Setter<T>({
    opt,
    type = typeof opt.value as RowProps<T>["type"],
    enums,
    max = 1000,
    min = 0,
}: RowProps<T>) {
    switch (type) {
        case "number": {
            const spin = new Gtk.SpinButton({ visible: true })
            spin.set_range(min, max)
            spin.set_increments(1, 5)
            spin.value = opt.value as number
            spin.connect("value-changed", () => { opt.value = spin.value as T })
            opt.connect("changed", () => { spin.value = opt.value as number })
            return spin
        }

        case "float":
        case "object": return (
            <entry
                onActivate={(self: any) => { opt.value = JSON.parse(self.text || "") }}
                setup={(self: any) => {
                    const update = () => { self.text = JSON.stringify(opt.value) }
                    update()
                    opt.connect("changed", update)
                }}
            />
        )

        case "string": return (
            <entry
                onActivate={(self: any) => { opt.value = self.text as T }}
                setup={(self: any) => {
                    const update = () => { self.text = opt.value as string }
                    update()
                    opt.connect("changed", update)
                }}
            />
        )

        case "enum": return EnumSetter(opt as unknown as Opt<string>, enums!)

        case "boolean": return (
            <switch
                setup={(self: any) => {
                    const update = () => { self.active = opt.value as boolean }
                    update()
                    opt.connect("changed", update)
                    self.connect("notify::active", () => { opt.value = self.active as T })
                }}
            />
        )

        case "img": {
            const btn = new Gtk.FileChooserButton({ visible: true })
            btn.connect("file-set", () => {
                const uri = btn.get_uri()
                if (uri) opt.value = uri.replace("file://", "") as T
            })
            return btn
        }

        case "font": {
            const btn = new Gtk.FontButton({ show_size: false, use_size: false, visible: true })
            const updateFont = () => { btn.font = opt.value as string }
            updateFont()
            opt.connect("changed", updateFont)
            btn.connect("font-set", () => {
                if (btn.font) opt.value = btn.font.split(" ").slice(0, -1).join(" ") as T
            })
            return btn
        }

        case "color": {
            const btn = new Gtk.ColorButton({ visible: true })
            const updateColor = () => {
                const rgba = new Gdk.RGBA()
                rgba.parse(opt.value as string)
                btn.rgba = rgba
            }
            updateColor()
            opt.connect("changed", updateColor)
            btn.connect("color-set", () => {
                const { red, green, blue } = btn.rgba
                const hex = (n: number) => {
                    const c = Math.floor(255 * n).toString(16)
                    return c.length === 1 ? `0${c}` : c
                }
                opt.value = `#${hex(red)}${hex(green)}${hex(blue)}` as T
            })
            return btn
        }

        default: return <label label={`no setter with type ${type}`} />
    }
}
