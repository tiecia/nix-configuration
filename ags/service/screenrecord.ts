import GLib from "gi://GLib"
import icons from "lib/icons"
import { dependencies, sh, bash } from "lib/utils"
import { interval } from "lib/timer"

const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const notifd = Notifd?.get_default?.() ?? null
const now = () => GLib.DateTime.new_now_local().format("%Y-%m-%d_%H-%M-%S")

class Recorder {
    timer = 0
    recording = false
    private _nextListenerId = 1
    private _listeners = new Map<number, { signal: string, callback: () => void }>()

    #recordings = GLib.get_home_dir() + "/Videos/Screencasting"
    #screenshots = GLib.get_home_dir() + "/Pictures/Screenshots"
    #file = ""
    #intervalId = 0

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

    getRecording() {
        return this.recording
    }

    getTimer() {
        return this.timer
    }

    async start() {
        if (!dependencies("slurp", "wf-recorder"))
            return

        if (this.recording)
            return

        GLib.mkdir_with_parents(this.#recordings, 0o755)
        this.#file = `${this.#recordings}/${now()}.mp4`
        sh(`wf-recorder -g "${await sh("slurp")}" -f ${this.#file} --pixel-format yuv420p`)

        this.recording = true
        this._emit("changed")

        this.timer = 0
        this.#intervalId = interval(1000, () => {
            this.timer++
            this._emit("changed")
        }) as any as number
    }

    async stop() {
        if (!this.recording)
            return

        await bash("killall -INT wf-recorder")
        this.recording = false
        this._emit("changed")

        try {
            GLib.source_remove(this.#intervalId)
        } catch {
            // Source may have already been removed
        }

        notifd?.notify?.({
            icon_name: icons.fallback.video,
            summary: "Screenrecord",
            body: this.#file,
        })

        // Show files action via separate notification
        setTimeout(() => {
            sh(`xdg-open ${this.#recordings}`).catch(() => {})
        }, 500)
    }

    async screenshot(full = false) {
        if (!dependencies("slurp", "wayshot"))
            return

        const file = `${this.#screenshots}/${now()}.png`
        GLib.mkdir_with_parents(this.#screenshots, 0o755)

        try {
            if (full) {
                await sh(`wayshot -f ${file}`)
            } else {
                const size = await sh("slurp")
                if (!size)
                    return

                await sh(`wayshot -f ${file} -s "${size}"`)
            }

            await bash(`wl-copy < ${file}`)

            notifd?.notify?.({
                image: file,
                summary: "Screenshot",
                body: file,
            })

            // Show/View/Edit actions via separate calls
            setTimeout(() => {
                sh(`xdg-open ${this.#screenshots}`).catch(() => {})
            }, 500)
        } catch (err) {
            console.error("Screenshot failed", err)
        }
    }
}

const recorder = new Recorder()
Object.assign(globalThis, { recorder })
export default recorder
