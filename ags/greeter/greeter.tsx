import "./session"
import "style/style"
import app from "ags/gtk3/app"
import RegularWindow from "widget/RegularWindow"
import statusbar from "./statusbar"
import Auth, { focusPassword } from "./auth"

app.start({
    main() {
        const win = RegularWindow({
            name: "greeter",
            setup: (self: any) => {
                self.set_default_size(500, 500)
                self.show_all()
                focusPassword()
            },
            child: (
                <overlay>
                    <box expand />
                    <box vpack="start" hpack="fill" hexpand>
                        {statusbar}
                    </box>
                    <box vpack="center" hpack="center">
                        <Auth />
                    </box>
                </overlay>
            ),
        })
        app.add_window(win)
    },
})
