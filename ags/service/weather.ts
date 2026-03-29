import GObject from "gi://GObject?version=2.0"
import { register, property, signal } from "ags/gobject"
import { fetch } from "ags/fetch"
import { interval } from "lib/timer"
import options from "options"

const { interval: intervalOption, key, cities, unit } = options.datemenu.weather

@register()
class Weather extends GObject.Object {
    @property(Object)
    forecasts: Forecast[] = []

    async #fetch(placeid: number) {
        const url = "https://api.openweathermap.org/data/2.5/forecast"
        const res = await fetch(url, {
            params: {
                id: placeid,
                appid: key.value,
                untis: unit.value,
            },
        })
        return await res.json()
    }

    constructor() {
        super()
        if (!key.value)
            return

        interval(intervalOption.value, () => {
            Promise.all(cities.value.map(this.#fetch.bind(this))).then(forecasts => {
                this.forecasts = forecasts as Forecast[]
                this.notify("forecasts")
            })
        })
    }
}

export default new Weather

type Forecast = {
    city: {
        name: string,
    }
    list: Array<{
        dt: number
        main: {
            temp: number
            feels_like: number
        },
        weather: Array<{
            main: string,
            description: string,
            icon: string,
        }>
    }>
}
