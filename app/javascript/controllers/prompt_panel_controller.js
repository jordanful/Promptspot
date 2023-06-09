import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["panel", "doneButton", "list", "prompt", "input", "promptIds", "inputIds", "selectedPrompts", "selectedInputs", "headline", "search", "overlay", "newPromptTextArea"]

    connect() {
        this.handleClick = this.handleClick.bind(this)
        document.addEventListener('click', this.handleClick)
    }

    disconnect() {
        document.removeEventListener('click', this.handleClick)
    }

    handleClick(event) {
        if (this.panelTarget.style.display === 'block' && !this.panelTarget.contains(event.target)) {
            this.close(event)
        }
    }

    openPrompt(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('prompts')
        this.headlineTarget.innerText = 'Select one or more prompts'
        this.activeTarget = this.promptIdsTarget
        this.activeListTarget = this.selectedPromptsTarget
        this.showDoneButton()
    }

    openNewPrompt(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('new_prompt')
        this.headlineTarget.innerText = 'New prompt'
        this.newPromptTextAreaTarget.focus()
        this.hideDoneButton()
    }

    openInput(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('inputs')
        this.headlineTarget.innerText = 'Select one or more inputs'
        this.activeTarget = this.inputIdsTarget
        this.activeListTarget = this.selectedInputsTarget
        this.showDoneButton()
    }

    openNewInput(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('new_input')
        this.headlineTarget.innerText = 'New input'
        this.hideDoneButton()
    }

    showSection(id) {
        // Hide all sections first
        ['prompts', 'new_prompt', 'inputs', 'new_input'].forEach((sectionId) => {
            document.getElementById(sectionId).style.display = 'none'
        })

        // Show the specific section
        document.getElementById(id).style.display = 'block'
        this.openPanel()
    }

    showDoneButton() {
        this.doneButtonTarget.style.display = 'block'
    }

    hideDoneButton() {
        this.doneButtonTarget.style.display = 'none'
    }

    openPanel() {
        this.overlayTarget.classList.add('overlay-open')
        this.panelTarget.classList.add('panel-open')
    }

    close(event) {
        event.preventDefault()
        this.overlayTarget.classList.remove('overlay-open')
        this.panelTarget.classList.remove('panel-open')
    }

    search(event) {
        // Handle search logic here
        // Probably make a server request to filter the prompts
        // And update the this.listTarget
    }

    selectPrompt(event) {
        event.preventDefault()
        const promptId = event.currentTarget.dataset.promptId
        if (!this.activeTarget.value.split(',').includes(promptId)) {
            this.activeTarget.value = this.activeTarget.value ? `${this.activeTarget.value},${promptId}` : promptId
            // Add 'selected' class to highlight this prompt
            event.currentTarget.classList.add('selected')
        } else {
            this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== promptId).join(',')
            // Remove 'selected' class since this prompt is deselected
            event.currentTarget.classList.remove('selected')
        }
        // Update the this.activeListTarget with the selected or deselected prompt
    }


    selectInput(event) {
        event.preventDefault()
        const inputId = event.currentTarget.dataset.inputId
        if (!this.activeTarget.value.split(',').includes(inputId)) {
            this.activeTarget.value = this.activeTarget.value ? `${this.activeTarget.value},${inputId}` : inputId
            // Add 'selected' class to highlight this input
            event.currentTarget.classList.add('selected')
        } else {
            this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== inputId).join(',')
            // Remove 'selected' class since this input is deselected
            event.currentTarget.classList.remove('selected')
        }
        // Update the this.activeListTarget with the selected or deselected input
    }


}
