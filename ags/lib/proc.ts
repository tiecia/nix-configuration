import Gio from "gi://Gio?version=2.0"
import GLib from "gi://GLib?version=2.0"

function toArgv(cmd: string | string[]) {
    if (Array.isArray(cmd)) {
        return cmd
    }

    const [, argv] = GLib.shell_parse_argv(cmd)
    return argv ?? []
}

export function exec(cmd: string | string[]) {
    const argv = toArgv(cmd)
    const proc = Gio.Subprocess.new(
        argv,
        Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE,
    )

    const [, stdout, stderr] = proc.communicate_utf8(null, null)
    if (!proc.get_successful()) {
        throw new Error((stderr || "command failed").trim())
    }

    return (stdout || "").trim()
}

export function execAsync(cmd: string | string[]) {
    const argv = toArgv(cmd)
    const proc = Gio.Subprocess.new(
        argv,
        Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE,
    )

    return new Promise<string>((resolve, reject) => {
        proc.communicate_utf8_async(null, null, (_proc, res) => {
            try {
                const [, stdout, stderr] = proc.communicate_utf8_finish(res)
                if (!proc.get_successful()) {
                    reject(new Error((stderr || "command failed").trim()))
                    return
                }

                resolve((stdout || "").trim())
            } catch (error) {
                reject(error)
            }
        })
    })
}
