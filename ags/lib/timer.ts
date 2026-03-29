import GLib from "gi://GLib?version=2.0"

export function timeout(ms: number, callback: () => void) {
    return GLib.timeout_add(GLib.PRIORITY_DEFAULT, Math.max(0, Math.floor(ms)), () => {
        callback()
        return GLib.SOURCE_REMOVE
    })
}

export function interval(ms: number, callback: () => void) {
    return GLib.timeout_add(GLib.PRIORITY_DEFAULT, Math.max(1, Math.floor(ms)), () => {
        callback()
        return GLib.SOURCE_CONTINUE
    })
}

export function idle(callback: () => void) {
    return GLib.idle_add(GLib.PRIORITY_DEFAULT_IDLE, () => {
        callback()
        return GLib.SOURCE_REMOVE
    })
}
