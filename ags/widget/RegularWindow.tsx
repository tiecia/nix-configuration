import Gtk from "gi://Gtk?version=3.0"
import { register } from "ags/gobject"

// In AGS v3, we use JSX for widget creation directly
// RegularWindow is now a simple JSX window helper
export default (props: Record<string, any>) => <window {...props} />
