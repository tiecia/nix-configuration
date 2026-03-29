import GLib from "gi://GLib?version=2.0"
import Gdk from "gi://Gdk?version=3.0"
import Gtk from "gi://Gtk?version=3.0"

declare global {
    const OPTIONS: string
    const TMP: string
    const USER: string
    const CONFIG_DIR: string
}

const configDir = GLib.build_filenamev([GLib.get_user_config_dir(), "ags"])

Object.assign(globalThis, {
    OPTIONS: `${GLib.get_user_cache_dir()}/ags/options.json`,
    TMP: `${GLib.get_tmp_dir()}/asztal`,
    USER: GLib.get_user_name(),
    CONFIG_DIR: configDir,
})

GLib.mkdir_with_parents(TMP, 0o755)

// Add icon search path for assets
const screen = Gdk.Screen.get_default()
if (screen) {
    const theme = Gtk.IconTheme.get_for_screen(screen)
    theme.append_search_path(`${configDir}/assets`)
}
