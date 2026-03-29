import { createBinding } from "ags"
import PanelButton from "../PanelButton"
import options from "options"

const { icon, label, action } = options.bar.launcher

function Spinner() {
    return (
        <revealer
            transitionType="slide_left"
            revealChild={createBinding(icon.icon).as((i) => Boolean(i))}
        >
            <icon
                icon={createBinding(icon.icon)}
                className={createBinding(icon.colored).as((c) => `${c ? "colored" : ""}`)}
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
    )
}

export default () => PanelButton({
    window: "launcher",
    onClicked: () => action.value(),
    child: (
        <box>
            <Spinner />
            <label
                className={createBinding(label.colored).as(c => c ? "colored" : "")}
                visible={createBinding(label.label).as(v => !!v)}
                label={createBinding(label.label)}
            />
        </box>
    ),
})
