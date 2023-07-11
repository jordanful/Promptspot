import {Controller} from "stimulus"

export default class extends Controller {

    viewByPrompt(event) {
        document.getElementById("selectPrompt").style.display = "block"
        document.getElementById("selectContext").style.display = "none"

        document.getElementById("viewByPrompt").classList.add("bg-blue-100", "dark:bg-slate-700")
        document.getElementById("viewByContext").classList.add("dark:bg-opacity-10", "dark:hover:bg-white", "dark:hover:bg-opacity-50", "hover:bg-blue-50")
        document.getElementById("viewByContext").classList.remove("bg-blue-100", "dark:bg-slate-700")

        document.getElementById("contextDropdown").classList.add("hidden")
        document.getElementById("promptDropdown").classList.remove("hidden")

        window.dispatchEvent(new CustomEvent('tab-switch', {detail: {tab: 'prompt'}}));
    }

    viewByContext(event) {
        document.getElementById("selectPrompt").style.display = "none"
        document.getElementById("selectContext").style.display = "block"

        document.getElementById("viewByPrompt").classList.add("dark:bg-opacity-10", "dark:hover:bg-white", "dark:hover:bg-opacity-50", "hover:bg-blue-50")
        document.getElementById("viewByPrompt").classList.remove("bg-blue-100", "dark:bg-slate-700")

        document.getElementById("viewByContext").classList.add("bg-blue-100", "dark:bg-slate-700")
        document.getElementById("viewByContext").classList.remove("dark:bg-opacity-10", "dark:hover:bg-white", "dark:hover:bg-opacity-50", "hover:bg-blue-50")

        document.getElementById("promptDropdown").classList.add("hidden")
        document.getElementById("contextDropdown").classList.remove("hidden")

        window.dispatchEvent(new CustomEvent('tab-switch', {detail: {tab: 'context'}}));
    }
}
