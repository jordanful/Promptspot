// app/javascript/controllers/api_key_controller.js

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

            // focus the field and select all the text
            keyField.focus()
            keyField.select()
        } else {
            keyField.type = "password"
            eyeIcon.style.display = ""
            eyeOffIcon.style.display = "none"

            // blur the field and deselect the key
            keyField.blur()
            window.getSelection().removeAllRanges()
        }
    }

    copyKeyToClipboard() {
        const keyField = this.keyFieldTarget
        keyField.select()
        document.execCommand("copy")

        this.showFlashMessage("👍 Copied")
    }

    showFlashMessage(message) {
        const flashContainer = document.getElementById("flash-container")
        const flashMessage = `
      <div class="fixed inset-x-0 top-0 flex items-center justify-center mt-5">
        <div class="py-2 px-3 bg-black text-white rounded-lg inline-flex items-center justify-center rounded-md shadow transform transition-opacity duration-300">
          ${message}
        </div>
      </div>
    `
        flashContainer.innerHTML += flashMessage

        // Remove the flash message after 3 seconds
        setTimeout(() => {
            flashContainer.removeChild(flashContainer.firstChild)
        }, 3000)
    }
}
