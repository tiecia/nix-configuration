import Group from "./Group"

export default (
    name: string,
    icon: string,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    ...groups: ReturnType<typeof Group>[]
) => {
    const w = (
        <box className="page">
            <scrollable css="min-height: 300px;">
                <box className="page-content" vexpand vertical>
                    {groups}
                </box>
            </scrollable>
        </box>
    ) as any
    return Object.assign(w, { name, icon })
}
