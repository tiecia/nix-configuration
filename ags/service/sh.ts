import GLib from "gi://GLib?version=2.0"
import GObject from "gi://GObject?version=2.0"
import { execAsync } from "lib/proc"
import { writeFile } from "ags/file"
import { bash, dependencies } from "lib/utils"
import icons from "lib/icons"
import options from "options"
import { register } from "ags/gobject"

const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const notifd = Notifd?.get_default?.() ?? null

const MAX = options.launcher.sh.max
const BINS = `${GLib.get_user_cache_dir()}/ags/binaries`

async function ls(path: string) {
    return execAsync(`ls ${path}`).catch(() => "")
}

async function reload() {
    const bins = await Promise.all(GLib.getenv("PATH")!
        .split(":")
        .map(ls))

    writeFile(BINS, bins.join("\n"))
}

async function query(filter: string) {
    if (!dependencies("fzf"))
        return [] as string[]

    return bash(`cat ${BINS} | fzf -f ${filter} | head -n ${MAX}`)
        .then(str => Array.from(new Set(str.split("\n").filter(i => i)).values()))
        .catch(err => { print(err); return [] })
}

function run(args: string) {
    execAsync(args)
        .then(out => {
            print(`:sh ${args.trim()}:`)
            print(out)
        })
        .catch(err => {
            notifd?.notify?.({
                summary: "ShRun Error",
                body: err,
                appIcon: icons.app.terminal,
            })
        })
}

@register()
class Sh extends GObject.Object {
    query = query
    run = run

    constructor() {
        super()
        reload()
    }
}

export default new Sh
