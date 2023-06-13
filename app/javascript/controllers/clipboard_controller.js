import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["output", "copyIcon", "copyText"]

    connect() {
        this.defaultIcon = this.copyIconTarget.innerHTML
        this.defaultText = this.copyTextTarget.innerHTML
    }

    copy(event) {
        event.preventDefault()
        navigator.clipboard.writeText(this.outputTarget.textContent).then(() => {
            this.copyFeedback()
        }).catch(err => {
            console.error('Failed to copy text: ', err)
        })
    }

    copyFeedback() {
        this.copyIconTarget.innerHTML = "&#x2713;"
        this.copyTextTarget.innerHTML = "Copied"

        setTimeout(() => {
            this.resetButton()
        }, 4000)
    }

    resetButton() {
        this.copyIconTarget.innerHTML = this.defaultIcon
        this.copyTextTarget.innerHTML = this.defaultText
    }
}
