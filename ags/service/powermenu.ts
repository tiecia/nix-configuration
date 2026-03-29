import { exec } from "lib/proc"
import options from "options"

const { sleep, reboot, logout, lock, shutdown } = options.powermenu

export type Action = "sleep" | "reboot" | "logout" | "shutdown" | "lock"

class PowerMenu {
    title = ""

    cmd = ""
    private _nextListenerId = 1
    private _listeners = new Map<number, { signal: string, callback: () => void }>()

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

    getTitle() {
        return this.title
    }

    getCmd() {
        return this.cmd
    }

    action(action: Action) {
        const actions: Record<Action, [string, string]> = {
            sleep: [sleep.value, "Sleep"],
            reboot: [reboot.value, "Reboot"],
            logout: [logout.value, "Log Out"],
            lock: [lock.value, "Lock"],
            shutdown: [shutdown.value, "Shutdown"],
        }

        const [cmd, title] = actions[action] || ["", ""]
        this.cmd = cmd
        this.title = title

        this._emit("changed")
    }

    readonly doShutdown = () => {
        this.action("shutdown")
    }

    readonly execute = () => {
        try {
            exec(this.cmd)
        } catch (err) {
            console.error("Failed to execute power menu command", err)
        }
    }
}

const powermenu = new PowerMenu()
Object.assign(globalThis, { powermenu })
export default powermenu
