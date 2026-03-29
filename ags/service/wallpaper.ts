import GLib from "gi://GLib?version=2.0"
import { monitorFile } from "ags/file"
import { fetch } from "ags/fetch"
import options from "options"
import { dependencies, sh } from "lib/utils"

export type Resolution = 1920 | 1366 | 3840
export type Market =
    | "random"
    | "en-US"
    | "ja-JP"
    | "en-AU"
    | "en-GB"
    | "de-DE"
    | "en-NZ"
    | "en-CA"

const HOME = GLib.get_home_dir()
const WP = `${HOME}/.config/background`
const Cache = `${HOME}/Pictures/Wallpapers/Bing`

class Wallpaper {
    private _nextListenerId = 1
    private _listeners = new Map<number, { signal: string, callback: () => void }>()

    #blockMonitor = false

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

    #wallpaper() {
        if (!dependencies("swww"))
            return

        sh("hyprctl cursorpos").then(pos => {
            sh([
                "swww", "img",
                "--invert-y",
                "--transition-type", "grow",
                "--transition-pos", pos.replace(" ", ""),
                WP,
            ]).then(() => {
                this._emit("changed")
            })
        })
    }

    async #setWallpaper(path: string) {
        this.#blockMonitor = true

        await sh(`cp ${path} ${WP}`)
        this.#wallpaper()

        this.#blockMonitor = false
    }

    async #fetchBing() {
        const res = await fetch("https://bing.biturl.top/", {
            params: {
                resolution: options.wallpaper.resolution.value,
                format: "json",
                image_format: "jpg",
                index: "random",
                mkt: options.wallpaper.market.value,
            },
        }).then(res => res.text())

        if (!res.startsWith("{"))
            return console.warn("bing api", res)

        const { url } = JSON.parse(res)
        const file = `${Cache}/${url.replace("https://www.bing.com/th?id=", "")}`

        if (dependencies("curl")) {
            GLib.mkdir_with_parents(Cache, 0o755)
            await sh(`curl "${url}" --output ${file}`)
            this.#setWallpaper(file)
        }
    }

    readonly random = () => { this.#fetchBing() }
    readonly set = (path: string) => { this.#setWallpaper(path) }
    get wallpaper() { return WP }

    constructor() {
        if (!dependencies("swww"))
            return

        // gtk portal
        if (monitorFile(WP, () => {
            if (!this.#blockMonitor)
                this.#wallpaper()
        })) {
            // monitor established
        }

        // execAsync("swww-daemon")
        //     .then(() => this.#wallpaper())
        //     .catch(() => null)
    }
}

export default new Wallpaper
