import { execAsync } from "lib/utils"
import icons from "lib/icons"
import sh from "service/sh"

let iconRevealerRef: any = null

function Item(bin: string) {
    return (
        <box vertical>
            <Gtk.Separator visible />
            <button
                className="sh-item"
                onClicked={() => {
                    execAsync(bin)
                    globalThis.app?.get_window("launcher")?.set_visible(false)
                }}
            >
                <label label={bin} hpack="start" />
            </button>
        </box>
    ) as any
}

import Gtk from "gi://Gtk?version=3.0"

export function Icon() {
    return (
        <revealer
            transitionType="slide_left"
            ref={(self: any) => { iconRevealerRef = self }}
        >
            <icon icon={icons.app.terminal} className="spinner" />
        </revealer>
    ) as any
}

export function ShRun() {
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
            const found = await sh.query(term)
            if (listRef) listRef.children = found.map(Item)
            if (revealerRef) revealerRef.revealChild = true
        }
    }

    return Object.assign(revealer, {
        filter,
        run: sh.run,
    })
}
