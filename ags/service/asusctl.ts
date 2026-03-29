import GObject from "gi://GObject?version=2.0"
import { register, property } from "ags/gobject"
import { sh } from "lib/utils"
import { exec } from "lib/proc"

type Profile = "Performance" | "Balanced" | "Quiet"
type Mode = "Hybrid" | "Integrated"

@register()
class Asusctl extends GObject.Object {
    @property(String)
    profile: Profile = "Balanced"

    @property(String)
    mode: Mode = "Hybrid"

    constructor() {
        super()

        if (this._available()) {
            sh("asusctl profile -p").then(p => {
                this.profile = p.split(" ")[3] as Profile
            })
            sh("supergfxctl -g").then(m => {
                this.mode = m as Mode
            })
        }
    }

    private _available: () => boolean = () => {
        try {
            exec("which asusctl")
            return true
        } catch {
            return false
        }
    }

    async nextProfile() {
        await sh("asusctl profile -n")
        const profile = await sh("asusctl profile -p")
        const p = profile.split(" ")[3] as Profile
        this.profile = p
    }

    async setProfile(prof: Profile) {
        await sh(`asusctl profile --profile-set ${prof}`)
        this.profile = prof
    }

    async nextMode() {
        await sh(`supergfxctl -m ${this.mode === "Hybrid" ? "Integrated" : "Hybrid"}`)
        this.mode = await sh("supergfxctl -g") as Mode
    }

    get profiles(): Profile[] {
        return ["Performance", "Balanced", "Quiet"]
    }
}

export default new Asusctl()
