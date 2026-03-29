import { icon as resolveIcon } from "lib/utils"
import icons from "lib/icons"
import options from "options"

type ClientLike = {
    address: string
    size: [number, number]
    class: string
    title: string
}

export default function Window({ client }: { client: ClientLike }) {
    const [w, h] = client.size

    return (
        <button
            className="client"
            tooltipText={client.title}
            onClicked={() => {
                // focus and close overview
                void globalThis.app?.get_window("overview")?.set_visible(false)
            }}
        >
            <icon
                css={`
                    min-width: ${(options.overview.scale.value / 100) * w}px;
                    min-height: ${(options.overview.scale.value / 100) * h}px;
                `}
                icon={resolveIcon(
                    `${client.class}${options.overview.monochromeIcon.value ? "-symbolic" : ""}`,
                    `${icons.fallback.executable}${options.overview.monochromeIcon.value ? "-symbolic" : ""}`,
                )}
            />
        </button>
    )
}
