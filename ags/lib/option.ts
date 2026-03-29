import GLib from "gi://GLib"
import { readFile, writeFile, monitorFile } from "ags/file"

type OptProps = {
    persistent?: boolean
}

export class Opt<T = unknown> {
    constructor(initial: T, { persistent = false }: OptProps = {}) {
        this.initial = initial
        this._value = initial
        this.persistent = persistent
    }

    initial: T
    id = ""
    persistent: boolean
    private _value: T
    private _nextListenerId = 1
    private _listeners = new Map<number, { signal: string, callback: () => void }>()

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
            if (sig === signal) {
                callback()
            }
        }
    }

    bind() {
        return {
            as: <U>(fn: (v: T) => U) => fn(this._value),
        }
    }

    get value(): T {
        return this._value
    }

    set value(v: T) {
        if (JSON.stringify(this._value) !== JSON.stringify(v)) {
            this._value = v
            this._emit("changed")
        }
    }

    toString() {
        return `${this.value}`
    }

    toJSON() {
        return `opt:${this.value}`
    }

    init(cacheFile: string) {
        try {
            const cache = JSON.parse(readFile(cacheFile) || "{}")
            const cacheV = cache[this.id]
            if (cacheV !== undefined) {
                this._value = cacheV
            }
        } catch (err) {
            // File doesn't exist yet, skip
        }

        this.connect("changed", () => {
            try {
                const cache = JSON.parse(readFile(cacheFile) || "{}")
                cache[this.id] = this.value
                writeFile(cacheFile, JSON.stringify(cache, null, 2))
            } catch (err) {
                console.error("Failed to cache option", err)
            }
        })
    }

    reset() {
        if (this.persistent) return

        if (JSON.stringify(this.value) !== JSON.stringify(this.initial)) {
            this.value = this.initial
            return this.id
        }
    }
}

export const opt = <T>(initial: T, opts?: OptProps) => new Opt(initial, opts)

function getOptions(object: object, path = ""): Opt[] {
    return Object.keys(object).flatMap(key => {
        const obj: Opt = object[key]
        const id = path ? path + "." + key : key

        if (obj instanceof Opt) {
            obj.id = id
            return obj
        }

        if (typeof obj === "object" && obj !== null)
            return getOptions(obj, id)

        return []
    })
}

export function mkOptions<T extends object>(cacheFile: string, object: T) {
    for (const opt of getOptions(object)) {
        opt.init(cacheFile)
    }

    GLib.mkdir_with_parents(cacheFile.split("/").slice(0, -1).join("/"), 0o755)

    const configFile = `${globalThis.TMP}/config.json`
    const values = getOptions(object).reduce((obj, { id, value }) => ({ [id]: value, ...obj }), {})
    writeFile(configFile, JSON.stringify(values, null, 2))

    monitorFile(configFile, () => {
        try {
            const cache = JSON.parse(readFile(configFile) || "{}")
            for (const opt of getOptions(object)) {
                if (JSON.stringify(cache[opt.id]) !== JSON.stringify(opt.value))
                    opt.value = cache[opt.id]
            }
        } catch (err) {
            console.error("Failed to read config file", err)
        }
    })

    function sleep(ms = 0) {
        return new Promise(r => setTimeout(r, ms))
    }

    async function reset(
        [opt, ...list] = getOptions(object),
        id = opt?.reset(),
    ): Promise<Array<string>> {
        if (!opt)
            return sleep().then(() => [])

        return id
            ? [id, ...(await sleep(50).then(() => reset(list)))]
            : await sleep().then(() => reset(list))
    }

    return Object.assign(object, {
        configFile,
        array: () => getOptions(object),
        async reset() {
            return (await reset()).join("\n")
        },
        handler(deps: string[], callback: () => void) {
            for (const opt of getOptions(object)) {
                if (deps.some(i => opt.id.startsWith(i)))
                    opt.connect("changed", callback)
            }
        },
    })
}

