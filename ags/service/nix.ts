import GObject from "gi://GObject?version=2.0"
import GLib from "gi://GLib"
import { register, property } from "ags/gobject"
import icons from "lib/icons"
import { bash, dependencies } from "lib/utils"
import { exec, execAsync } from "lib/proc"
import { writeFile } from "ags/file"
import options from "options"

const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const CACHE = `${GLib.get_user_cache_dir()}/ags/nixpkgs`
const PREFIX = "legacyPackages.x86_64-linux."
const notifd = Notifd?.get_default?.() ?? null

export type Nixpkg = {
    name: string
    description: string
    pname: string
    version: string
}

@register()
class Nix extends GObject.Object {
    @property(Boolean)
    available = false

    @property(Boolean)
    ready = true

    #db: { [name: string]: Nixpkg } = {}

    constructor() {
        super()
        this._updateAvailable()
        if (this.available) {
            this._updateList()
            options.launcher.nix.pkgs.connect("changed", () => this._updateList())
        }
    }

    private _updateAvailable() {
        try {
            exec("which nix")
            this.available = true
        } catch {
            this.available = false
        }
    }

    get db() {
        return this.#db
    }

    getReady() {
        return this.ready
    }

    setReady(r: boolean) {
        this.ready = r
        this.notify("ready")
    }

    getAvailable() {
        return this.available
    }

    query = async (filter: string) => {
        const MAX = options.launcher.nix.max.value
        if (!dependencies("fzf", "nix") || !this.ready)
            return [] as string[]

        try {
            const result = await bash(`cat ${CACHE} | fzf -f ${filter} -e | head -n ${MAX}`)
            return result.split("\n").filter(i => i)
        } catch {
            return []
        }
    }

    nix(cmd: string, bin: string, args: string) {
        const nixpkgs = options.launcher.nix.pkgs.value
        return execAsync(`nix ${cmd} ${nixpkgs}#${bin} --impure ${args}`)
    }

    run = async (input: string) => {
        if (!dependencies("nix"))
            return

        try {
            const [bin, ...args] = input.trim().split(/\s+/)

            this.setReady(false)
            await this.nix("shell", bin, "--command sh -c 'exit'")
            this.setReady(true)

            this.nix("run", bin, ["--", ...args].join(" "))
        } catch (err) {
            if (typeof err === "string") {
                notifd?.notify?.({
                    summary: "NixRun Error",
                    body: err,
                    icon_name: icons.nix.nix,
                })
            } else {
                console.error(err)
            }
        } finally {
            this.setReady(true)
        }
    }

    #updateList = async () => {
        if (!dependencies("nix"))
            return

        this.setReady(false)
        this.#db = {}

        try {
            const search = await bash(`nix search ${options.launcher.nix.pkgs.value} --json`)
            if (!search) {
                this.setReady(true)
                return
            }

            const json = Object.entries(JSON.parse(search) as {
                [name: string]: Nixpkg
            })

            for (const [pkg, info] of json) {
                const name = pkg.replace(PREFIX, "")
                this.#db[name] = { ...info, name }
            }

            const list = Object.keys(this.#db).join("\n")
            writeFile(CACHE, list)
            this.setReady(true)
        } catch (err) {
            console.error("Failed to update nix package list", err)
            this.setReady(true)
        }
    }
}

export default new Nix()
