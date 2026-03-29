import GLib from "gi://GLib"
import { readFileAsync } from "ags/file"
import { interval } from "./timer"

class ReactiveValue<T> {
    private _value: T
    private _nextId = 1
    private _listeners = new Map<number, () => void>()

    constructor(initial: T) {
        this._value = initial
    }

    get value() {
        return this._value
    }

    set value(v: T) {
        if (v === this._value) return
        this._value = v
        for (const cb of this._listeners.values()) cb()
    }

    connect(signal: string, callback: () => void) {
        if (signal !== "changed") return 0
        const id = this._nextId++
        this._listeners.set(id, callback)
        return id
    }

    bind() {
        return {
            as: <U>(fn: (value: T) => U) => fn(this._value),
        }
    }
}

// import options from "options"
//
// const intval = options.system.fetchInterval.value
// const tempPath = options.system.temperature.value

export const clock = new ReactiveValue(GLib.DateTime.new_now_local())

export const uptime = new ReactiveValue(0)

interval(1000, () => {
    clock.value = GLib.DateTime.new_now_local()
})

interval(60_000, async () => {
    try {
        const line = await readFileAsync("/proc/uptime")
        uptime.value = Number.parseInt(line.split(".")[0]) / 60
    } catch {
        uptime.value = 0
    }
})

export const distro = {
    id: GLib.get_os_info("ID"),
    logo: GLib.get_os_info("LOGO"),
}

// const divide = ([total, free]: string[]) => Number.parseInt(free) / Number.parseInt(total)
//
// export const cpu = createPoll(0, intval, async () => {
//     const out = await (await import("ags/process")).execAsync("top -b -n 1")
//     return divide(["100", out.split("\n")
//         .find(line => line.includes("Cpu(s)"))
//         ?.split(/\s+/)[1]
//         .replace(",", ".") || "0"])
// })
//
// export const ram = createPoll(0, intval, async () => {
//     const out = await (await import("ags/process")).execAsync("free")
//     return divide(out.split("\n")
//         .find(line => line.includes("Mem:"))
//         ?.split(/\s+/)
//         .splice(1, 2) || ["1", "1"])
// })
//
// export const temperature = createPoll(0, intval, async () => {
//     const n = await (await import("ags/process")).readFileAsync(tempPath)
//     return Number.parseInt(n) / 100_000
//     }],
// })
