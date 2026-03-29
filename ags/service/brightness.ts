import { bash, dependencies, sh } from "lib/utils"
import { exec } from "lib/proc"
import { readFileAsync, monitorFile } from "ags/file"

const get = (args: string) => Number(exec(`brightnessctl ${args}`))

class Brightness {
    screen = 0

    kbd = 0
    private _nextListenerId = 1
    private _listeners = new Map<number, { signal: string, callback: () => void }>()

    #kbdMax = 100
    #kbd = 0
    #screenMax = 100

    connect(signal: string, callback: () => void) {
        const id = this._nextListenerId++
        this._listeners.set(id, { signal, callback })
        return id
    }

    private _emit(signal: string) {
        for (const { signal: sig, callback } of this._listeners.values()) {
            if (sig === signal || sig === "changed") callback()
        }
    }

    constructor() {
        this._initialize()
    }

    private async _initialize() {
        if (!dependencies("brightnessctl")) {
            console.error("brightnessctl not found")
            return
        }

        try {
            const screen = await bash`ls -w1 /sys/class/backlight | head -1`
            const kbd = await bash`ls -w1 /sys/class/leds | head -1`

            this.#kbdMax = get(`--device ${kbd} max`)
            this.#kbd = get(`--device ${kbd} get`)
            this.#screenMax = get("max")
            this.screen = get("get") / (get("max") || 1)
            this.kbd = this.#kbd

            const screenPath = `/sys/class/backlight/${screen}/brightness`
            const kbdPath = `/sys/class/leds/${kbd}/brightness`

            monitorFile(screenPath, async (f) => {
                const v = await readFileAsync(f)
                this.screen = Number(v) / this.#screenMax
                this._emit("changed")
            })

            monitorFile(kbdPath, async (f) => {
                const v = await readFileAsync(f)
                this.kbd = Number(v) / this.#kbdMax
                this._emit("changed")
            })

            this._emit("changed")
        } catch (err) {
            console.error("Failed to initialize brightness service", err)
        }
    }

    get screenValue() {
        return this.screen
    }

    get kbdValue() {
        return this.kbd
    }

    setKbd(value: number) {
        if (value < 0 || value > this.#kbdMax) return

        // Get kbd device name (we need to store it)
        bash`ls -w1 /sys/class/leds | head -1`.then(kbd => {
            sh(`brightnessctl -d ${kbd} s ${value} -q`).then(() => {
                this.kbd = value
                this._emit("changed")
            })
        })
    }

    setScreen(percent: number) {
        if (percent < 0) percent = 0
        if (percent > 1) percent = 1

        sh(`brightnessctl set ${Math.floor(percent * 100)}% -q`).then(() => {
            this.screen = percent
            this._emit("changed")
        })
    }
}

export default new Brightness()
