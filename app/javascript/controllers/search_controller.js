import {Controller} from "stimulus"
import {Turbo} from "@hotwired/turbo-rails"

export default class extends Controller {
    static targets = ["input"]


    filter() {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            const form = this.element
            Turbo.visit(form.action, {
                method: form.method,
                params: new URLSearchParams(new FormData(form)),
                frame: form.getAttribute("data-turbo-frame")
            })
        }, 300)
    }
}
