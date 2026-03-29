import icons from "./icons"

const Battery = await import("gi://AstalBattery")
    .then(mod => mod.default)
    .catch(() => null)

const Notifd = await import("gi://AstalNotifd")
    .then(mod => mod.default)
    .catch(() => null)

const notifd = Notifd?.get_default?.() ?? null

export default function init() {
    const battery = Battery?.get_default?.() ?? null
    if (!battery || !notifd) return
    
    battery.connect("notify::percentage", () => {
        const { percentage, charging } = battery
        const low = 30
        if (percentage !== low || percentage !== low / 2 || !charging)
            return

        notifd.notify({
            summary: `${percentage}% Battery Percentage`,
            icon_name: icons.battery.warning,
            urgency: 2, // critical
        })
    })
}
