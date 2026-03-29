import options from "options"

const AstalHyprland = await import("gi://AstalHyprland")
    .then(mod => mod.default)
    .catch(() => null)

const hyprland = AstalHyprland?.get_default?.() ?? null

const {
    hyprland: hyprlandOpts,
    theme: {
        spacing,
        radius,
        border: { width },
        blur,
        shadows,
        dark: {
            primary: { bg: darkActive },
        },
        light: {
            primary: { bg: lightActive },
        },
        scheme,
    },
} = options

const deps = [
    "hyprland",
    spacing.id,
    radius.id,
    blur.id,
    width.id,
    shadows.id,
    darkActive.id,
    lightActive.id,
    scheme.id,
]

function primary() {
    return scheme.value === "dark"
        ? darkActive.value
        : lightActive.value
}

function rgba(color: string) {
    return `rgba(${color}ff)`.replace("#", "")
}

async function sendBatch(batch: string[]) {
    if (!hyprland) return null

    const cmd = batch
        .filter(x => !!x)
        .map(x => `keyword ${x}`)
        .join("; ")

    return hyprland.message_async(`[[BATCH]]/${cmd}`)
}

async function setupHyprland() {
    if (!hyprland) return

    // const wm_gaps = Math.floor(hyprlandOpts.gaps.value * spacing.value)
    const wm_gaps = 0;

    await sendBatch([
        `general:border_size ${width.value}`,
        `general:gaps_out ${wm_gaps}`,
        `general:gain ${Math.floor(wm_gaps / 2)}`,
        `general:col.active_border ${rgba(primary())}`,
        `general:col.inactive_border ${rgba(hyprlandOpts.inactiveBorder.value)}`,
        `decoration:rounding ${radius.value}`,
        `decoration:drop_shadow ${shadows.value ? "yes" : "no"}`,
        `dwindle:no_gaps_when_only ${hyprlandOpts.gapsWhenOnly.value ? 0 : 1}`,
        `master:no_gaps_when_only ${hyprlandOpts.gapsWhenOnly.value ? 0 : 1}`,
    ])

    // TODO: need app instance to get windows
    // await sendBatch(app.get_windows().map(({ name }) => `layerrule unset, ${name}`))

    if (blur.value > 0) {
        // TODO: need app instance to get windows
        // await sendBatch(app.get_windows().flatMap(({ name }) => [
        //     `layerrule unset, ${name}`,
        //     `layerrule blur, ${name}`,
        //     `layerrule ignorealpha ${0.29}, ${name}`,
        // ]))
    }
}

export default function init() {
    // options.handler(deps, setupHyprland)
    // setupHyprland()
}
