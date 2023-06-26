import {Controller} from "stimulus"

export default class extends Controller {

    viewByPrompt(event) {
        document.getElementById("tableByPrompt").style.display = "block"
        document.getElementById("tableByInput").style.display = "none"
        document.getElementById("viewByPrompt").classList.add("bg-blue-100")
        document.getElementById("viewByPrompt").classList.add("hover:bg-blue-50")
        document.getElementById("viewByInput").classList.remove("bg-blue-100")
        document.getElementById("viewByPrompt").classList.remove("hover:bg-blue-50")
        document.getElementById("inputDropdown").classList.add("hidden")
        document.getElementById("promptDropdown").classList.remove("hidden")

    }

    viewByInput(event) {
        document.getElementById("tableByPrompt").style.display = "none"
        document.getElementById("tableByInput").style.display = "block"
        document.getElementById("viewByPrompt").classList.remove("bg-blue-100")
        document.getElementById("viewByInput").classList.add("bg-blue-100")
        document.getElementById("viewByInput").classList.add("hover:bg-blue-50")
        document.getElementById("viewByInput").classList.remove("hover:bg-blue-50")
        document.getElementById("promptDropdown").classList.add("hidden")
        document.getElementById("inputDropdown").classList.remove("hidden")
    }
}
