import GLib from "gi://GLib"
import icons from "lib/icons"
import { bash, dependencies } from "lib/utils"
import { readFile, writeFile } from "ags/file"

const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const COLORS_CACHE = GLib.get_user_cache_dir() + "/ags/colorpicker.json"
const MAX_NUM_COLORS = 10
const notifd = Notifd?.get_default?.() ?? null

class ColorPicker {
    colors: string[] = []
    private _nextListenerId = 1
    private _listeners = new Map<number, { signal: string, callback: () => void }>()

    #notifID = 0
    private _colors: string[] = []

    connect(signal: string, callback: () => void) {
        const id = this._nextListenerId++
        this._listeners.set(id, { signal, callback })
        return id
    }

    disconnect(id: number) {
        this._listeners.delete(id)
    }

    private _emit(signal: string) {
        for (const { signal: sig, callback } of this._listeners.values()) {
            if (sig === signal) callback()
        }
    }

    constructor() {
        try {
            this._colors = JSON.parse(readFile(COLORS_CACHE) || "[]") as string[]
            this.colors = [...this._colors]
        } catch {
            this._colors = []
            this.colors = []
        }
    }

    setColors(colors: string[]) {
        this._colors = colors
        this.colors = [...colors]
        this._emit("changed")
    }

    getColors() {
        return [...this._colors]
    }

    async wlCopy(color: string) {
        if (dependencies("wl-copy"))
            await bash(`wl-copy ${color}`)
    }

    readonly pick = async () => {
        if (!dependencies("hyprpicker"))
            return

        const color = await bash("hyprpicker -a -r")
        if (!color)
            return

        await this.wlCopy(color)
        const list = this.getColors()
        if (!list.includes(color)) {
            list.push(color)
            if (list.length > MAX_NUM_COLORS)
                list.shift()

            this.setColors(list)
            writeFile(COLORS_CACHE, JSON.stringify(list, null, 2))
        }

        this.#notifID = (notifd?.notify?.({
            id: this.#notifID,
            icon_name: icons.ui.colorpicker,
            summary: color,
        }) as number) || this.#notifID
    }
}

export default new ColorPicker()
