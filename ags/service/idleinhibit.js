import GObject from "gi://GObject?version=2.0"
import { register, property } from "ags/gobject"
import { exec } from "lib/proc"

@register()
class IdleInhibitor extends GObject.Object {
    @property(Boolean)
    inhibited

    _inhibited = false

    constructor() {
        super()
        this._updateState()
    }

    _updateState() {
        try {
            const state = exec("matcha -g")
            this._inhibited = state.trim() === "enabled"
        } catch {
            this._inhibited = false
        }
    }

    toggle() {
        try {
            exec("matcha -t")
            this._updateState()
        } catch (err) {
            console.error("Failed to toggle idle inhibitor", err)
        }
    }

    getInhibited() {
        return this._inhibited
    }
}

export default new IdleInhibitor()


