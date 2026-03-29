import wallpaper from "service/wallpaper"
import Gtk from "gi://Gtk?version=3.0"

export default () => {
    const fileBtn = new Gtk.FileChooserButton({ visible: true })
    fileBtn.connect("file-set", () => {
        const uri = fileBtn.get_uri()
        if (uri) wallpaper.set(uri.replace("file://", ""))
    })

    return (
        <box className="row wallpaper">
            <box vertical>
                <label
                    xalign={0}
                    className="row-title"
                    label="Wallpaper"
                    vpack="start"
                />
                <button onClicked={() => wallpaper.random()} label="Random" />
                {fileBtn as any}
            </box>
            <box hexpand />
            <box
                className="preview"
                setup={(self: any) => {
                    const update = () => {
                        self.css = `
                            min-height: 120px;
                            min-width: 200px;
                            background-image: url('${wallpaper.wallpaper}');
                            background-size: cover;
                        `
                    }
                    update()
                    wallpaper.connect("changed", update)
                }}
            />
        </box>
    )
}
