import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["keyField", "eyeIcon", "eyeOffIcon"]

    toggleKeyVisibility() {
        const keyField = this.keyFieldTarget
        const eyeIcon = this.eyeIconTarget
        const eyeOffIcon = this.eyeOffIconTarget

        if (keyField.type === "password") {
            keyField.type = "text"
            eyeIcon.style.display = "none"
            eyeOffIcon.style.display = ""

            keyField.focus()
            keyField.select()
        } else {
            keyField.type = "password"
            eyeIcon.style.display = ""
            eyeOffIcon.style.display = "none"

            keyField.blur()
            window.getSelection().removeAllRanges()
        }
    }

    copyKeyToClipboard() {
        const keyField = this.keyFieldTarget
        keyField.select()
        document.execCommand("copy")
        alert("API Key copied to clipboard.")
    }
}
