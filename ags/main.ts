import "lib/session"
import "style/style"
import init from "lib/init"
import options from "options"
import Bar from "widget/bar/Bar"
import NotificationPopups from "widget/notifications/NotificationPopups"
import OSD from "widget/osd/OSD"
import ScreenCorners from "widget/bar/ScreenCorners"
import Launcher from "widget/launcher/Launcher"
import Overview from "widget/overview/Overview"
import PowerMenu from "widget/powermenu/PowerMenu"
import SettingsDialog from "widget/settings/SettingsDialog"
import Verification from "widget/powermenu/Verification"
import { setupQuickSettings } from "widget/quicksettings/QuickSettings"
import { setupDateMenu } from "widget/datemenu/DateMenu"
import { forMonitors } from "lib/utils"
import app from "ags/gtk3/app"

const safeAdd = (label: string, factory: () => any[]) => {
    try {
        factory().forEach((win) => app.add_window(win))
    } catch (error) {
        console.warn(`[main] skipped ${label}:`, error)
    }
}

const safeCall = (label: string, fn: () => void) => {
    try {
        fn()
    } catch (error) {
        console.warn(`[main] skipped ${label}:`, error)
    }
}

const safeAddWindow = (label: string, factory: () => any) => {
    try {
        app.add_window(factory())
    } catch (error) {
        console.warn(`[main] skipped ${label}:`, error)
    }
}

app.start({
    instanceName: "test",
    main() {
        init()

        safeCall("quicksettings", setupQuickSettings)
        safeCall("datemenu", setupDateMenu)

        safeAdd("bar", () => forMonitors(Bar))
        safeAdd("notifications", () => forMonitors(NotificationPopups))
        safeAdd("screen-corners", () => forMonitors(ScreenCorners))
        safeAdd("osd", () => forMonitors(OSD))
        safeAddWindow("launcher", () => Launcher())
        safeAddWindow("overview", () => Overview())
        safeAddWindow("powermenu", () => PowerMenu())
        safeAddWindow("settings-dialog", () => SettingsDialog())
        safeAddWindow("verification", () => Verification())
    },
})
