import { createBinding } from "ags"
import Gtk from "gi://Gtk?version=3.0"
import AstalPowerProfiles from "gi://AstalPowerProfiles"
import { ArrowToggleButton, Menu } from "../ToggleButton"
import icons from "lib/icons"
import { execAsync } from "lib/utils"
import asusctl from "service/asusctl"

const pretty = (str: string) => str
    .split("-")
    .map((s: string) => `${s.at(0)?.toUpperCase()}${s.slice(1)}`)
    .join(" ")

const AsusProfileToggle = () => {
    const asusprof = createBinding(asusctl, "profile")
    return ArrowToggleButton({
        name: "asusctl-profile",
        icon: asusprof.as((p: string) => icons.asusctl.profile[p]) as any,
        label: asusprof.as((p: string) => p) as any,
        connection: [asusctl, () => asusctl.profile !== "Balanced"],
        activate: () => asusctl.setProfile("Quiet"),
        deactivate: () => asusctl.setProfile("Balanced"),
        activateOnArrow: false,
    })
}

const AsusProfileSelector = () => {
    const asusprof = createBinding(asusctl, "profile")
    return Menu({
        name: "asusctl-profile",
        icon: asusprof.as((p: string) => icons.asusctl.profile[p]) as any,
        title: "Profile Selector",
        content: [
            (
                <box vertical hexpand>
                    <box vertical>
                        {asusctl.profiles.map((prof: string) => (
                            <button onClicked={() => asusctl.setProfile(prof)}>
                                <box>
                                    <icon icon={icons.asusctl.profile[prof]} />
                                    <label label={prof} />
                                </box>
                            </button>
                        ))}
                    </box>
                </box>
            ) as any,
            new Gtk.Separator({ visible: true }),
            (
                <button onClicked={() => execAsync("rog-control-center")}>
                    <box>
                        <icon icon={icons.ui.settings} />
                        <label label="Rog Control Center" />
                    </box>
                </button>
            ) as any,
        ],
    })
}

const pp = AstalPowerProfiles.get_default()
const profiles = (pp.profiles as any[]).map((p: any) => p.profile ?? p.Profile ?? "").filter(Boolean)
const profile = createBinding(pp, "activeProfile")

const PowerProfileToggle = () => ArrowToggleButton({
    name: "asusctl-profile",
    icon: profile.as((p: string) => icons.powerprofile[p]) as any,
    label: profile.as(pretty) as any,
    connection: [pp, () => pp.activeProfile !== profiles[1]],
    activate: () => { pp.activeProfile = profiles[0] },
    deactivate: () => { pp.activeProfile = profiles[1] },
    activateOnArrow: false,
})

const PowerProfileSelector = () => Menu({
    name: "asusctl-profile",
    icon: profile.as((p: string) => icons.powerprofile[p]) as any,
    title: "Profile Selector",
    content: [
        (
            <box vertical hexpand>
                <box vertical>
                    {profiles.map((prof: string) => (
                        <button onClicked={() => { pp.activeProfile = prof }}>
                            <box>
                                <icon icon={icons.powerprofile[prof]} />
                                <label label={pretty(prof)} />
                            </box>
                        </button>
                    ))}
                </box>
            </box>
        ) as any,
    ],
})

export const ProfileToggle = asusctl.available
    ? AsusProfileToggle : PowerProfileToggle

export const ProfileSelector = asusctl.available
    ? AsusProfileSelector : PowerProfileSelector
