import { type BluetoothDevice } from "types/service/bluetooth"
import { createBinding } from "ags"
import Gtk from "gi://Gtk?version=3.0"
import AstalBluetooth from "gi://AstalBluetooth"
import { Menu, ArrowToggleButton } from "../ToggleButton"
import icons from "lib/icons"

const bluetooth = AstalBluetooth.get_default()

export const BluetoothToggle = () => ArrowToggleButton({
    name: "bluetooth",
    icon: createBinding(bluetooth, "enabled").as(
        (p: boolean) => icons.bluetooth[p ? "enabled" : "disabled"],
    ) as any,
    label: createBinding(bluetooth, "connectedDevices").as((devices: any[]) => {
        if (!bluetooth.enabled) return "Disabled"
        if (devices.length === 1) return (devices[0] as any).alias
        return devices.length === 0 ? "Disabled" : `${devices.length} Connected`
    }) as any,
    connection: [bluetooth, () => bluetooth.enabled],
    deactivate: () => { bluetooth.enabled = false },
    activate: () => { bluetooth.enabled = true },
})

const DeviceItem = (device: any) => (
    <box>
        <icon icon={`${device.icon}-symbolic`} />
        <label label={device.name} />
        <label
            label={createBinding(device, "batteryPercentage").as(
                (p: number) => ` ${p}%`,
            )}
            setup={(self: any) => {
                const u = () => { self.visible = device.batteryPercentage > 0 }
                u()
                device.connect("notify::battery-percentage", u)
            }}
        />
        <box hexpand />
        <Gtk.Spinner
            ref={(self: any) => {
                const u = () => { (self as any).active = device.connecting; (self as any).visible = device.connecting }
                u()
                device.connect("notify::connecting", u)
            }}
        />
        <switch
            setup={(self: any) => {
                const u = () => { self.visible = !device.connecting }
                u()
                device.connect("notify::connecting", u)
                self.active = device.connected
                self.connect("notify::active", () => {
                    device.connect_to?.() ?? device.setConnection?.(self.active)
                })
            }}
        />
    </box>
)

export const BluetoothDevices = () => Menu({
    name: "bluetooth",
    icon: icons.bluetooth.disabled,
    title: "Bluetooth",
    content: [
        (
            <box
                className="bluetooth-devices"
                hexpand
                vertical
                setup={(self: any) => {
                    const update = () => {
                        self.children = (bluetooth.devices as any[])
                            .filter((d: any) => d.name)
                            .map(DeviceItem)
                    }
                    update()
                    bluetooth.connect("notify::devices", update)
                }}
            />
        ) as any,
    ],
})
