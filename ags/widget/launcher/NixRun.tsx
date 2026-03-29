import Gtk from "gi://Gtk?version=3.0"
import icons from "lib/icons"
import nix, { type Nixpkg } from "service/nix"

let iconRevealerRef: any = null

function Item(pkg: Nixpkg) {
    const name = (
        <label className="name" label={pkg.name.split(".").at(-1) ?? ""} />
    )

    const subpkg = pkg.name.includes(".") ? (
        <label
            className="description"
            hpack="end"
            hexpand
            label={`  ${pkg.name.split(".").slice(0, -1).join(".")}`}
        />
    ) as any : null

    const version = (
        <label
            className="version"
            label={pkg.version}
            hexpand
            hpack="end"
        />
    )

    const description = pkg.description ? (
        <label
            className="description"
            label={pkg.description}
            justification="left"
            wrap
            hpack="start"
            maxWidthChars={40}
        />
    ) as any : null

    return (
        <box vertical>
            <Gtk.Separator visible />
            <button
                className="nix-item"
                onClicked={() => {
                    nix.run(pkg.name)
                    globalThis.app?.get_window("launcher")?.set_visible(false)
                }}
            >
                <box vertical>
                    <box>
                        {name}
                        {version}
                    </box>
                    <box>
                        {description}
                        {subpkg}
                    </box>
                </box>
            </button>
        </box>
    ) as any
}

export function Spinner() {
    return (
        <revealer
            transitionType="slide_left"
            ref={(self: any) => { iconRevealerRef = self }}
            setup={(self: any) => {
                const update = () => {
                    self.revealChild = !nix.ready || false
                    const icon = self.child
                    if (icon) icon.toggleClassName?.("spinning", !nix.ready)
                }
                update()
                nix.connect("notify::ready", update)
            }}
        >
            <icon
                icon={icons.nix.nix}
                className="spinner"
                css={`
                    @keyframes spin {
                        to { -gtk-icon-transform: rotate(1turn); }
                    }
                    image.spinning {
                        animation-name: spin;
                        animation-duration: 1s;
                        animation-timing-function: linear;
                        animation-iteration-count: infinite;
                    }
                `}
            />
        </revealer>
    ) as any
}

export function NixRun() {
    let listRef: any = null
    let revealerRef: any = null

    const list = (
        <box vertical ref={(self: any) => { listRef = self }} />
    ) as any

    const revealer = (
        <revealer ref={(self: any) => { revealerRef = self }}>
            {list}
        </revealer>
    ) as any

    async function filter(term: string) {
        if (iconRevealerRef) iconRevealerRef.revealChild = Boolean(term)

        if (!term) {
            if (revealerRef) revealerRef.revealChild = false
            return
        }

        if (term.trim()) {
            const found = await nix.query(term)
            if (listRef) listRef.children = found.map((k: string) => Item(nix.db[k]))
            if (revealerRef) revealerRef.revealChild = true
        }
    }

    return Object.assign(revealer, {
        filter,
        run: nix.run,
    })
}
