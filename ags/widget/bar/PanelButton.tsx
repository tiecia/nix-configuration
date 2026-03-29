import { ButtonProps } from "types/widgets/button"

type PanelButtonProps = ButtonProps & {
    window?: string,
    flat?: boolean
}

export default ({
    window = "",
    flat,
    child,
    className: _className,
    setup: _setup,
    onPrimaryClick,
    onSecondaryClick,
    onMiddleClick,
    onScrollUp,
    onScrollDown,
    ...rest
}: PanelButtonProps) => (
    <button
        onClicked={(self: any, event: any) => {
            const button = event?.button ?? event?.get_button?.()?.[1]
            if (button === 3 && typeof onSecondaryClick === "function") {
                onSecondaryClick(self)
                return
            }
            if (button === 2 && typeof onMiddleClick === "function") {
                onMiddleClick(self)
                return
            }
            if (typeof onPrimaryClick === "function") {
                onPrimaryClick(self)
            }
        }}
        onScroll={(self: any, event: any) => {
            const dir = event?.direction ?? event?.get_scroll_direction?.()?.[1]
            if (dir === 0 && typeof onScrollUp === "function") onScrollUp(self)
            if (dir === 1 && typeof onScrollDown === "function") onScrollDown(self)
        }}
        {...rest}
    >
        <box>
            {child}
        </box>
    </button>
)
