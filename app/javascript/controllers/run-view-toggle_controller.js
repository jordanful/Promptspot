import {Controller} from "stimulus"

export default class extends Controller {

    viewByPrompt(event) {
        document.getElementById("selectPrompt").style.display = "block"
        document.getElementById("selectInput").style.display = "none"

        document.getElementById("viewByPrompt").classList.add("bg-blue-100", "dark:bg-slate-700")
        document.getElementById("viewByInput").classList.add("dark:bg-opacity-10", "dark:hover:bg-white", "dark:hover:bg-opacity-50", "hover:bg-blue-50")
        document.getElementById("viewByInput").classList.remove("bg-blue-100", "dark:bg-slate-700")

        document.getElementById("inputDropdown").classList.add("hidden")
        document.getElementById("promptDropdown").classList.remove("hidden")

        window.dispatchEvent(new CustomEvent('tab-switch', {detail: {tab: 'prompt'}}));
    }

    viewByInput(event) {
        document.getElementById("selectPrompt").style.display = "none"
        document.getElementById("selectInput").style.display = "block"

        document.getElementById("viewByPrompt").classList.add("dark:bg-opacity-10", "dark:hover:bg-white", "dark:hover:bg-opacity-50", "hover:bg-blue-50")
        document.getElementById("viewByPrompt").classList.remove("bg-blue-100", "dark:bg-slate-700")

        document.getElementById("viewByInput").classList.add("bg-blue-100", "dark:bg-slate-700")
        document.getElementById("viewByInput").classList.remove("dark:bg-opacity-10", "dark:hover:bg-white", "dark:hover:bg-opacity-50", "hover:bg-blue-50")

        document.getElementById("promptDropdown").classList.add("hidden")
        document.getElementById("inputDropdown").classList.remove("hidden")

        window.dispatchEvent(new CustomEvent('tab-switch', {detail: {tab: 'input'}}));
    }
}
