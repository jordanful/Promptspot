import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["panel", "doneButton", "list", "promptIds", "userPromptIds", "selectedPrompts", "selectedUserPrompts", "headline", "search", "overlay"]

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
        this.hideDoneButton()
    }

    openUserPrompt(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('user_prompts')
        this.headlineTarget.innerText = 'Select one or more prompts'
        this.activeTarget = this.userPromptIdsTarget
        this.activeListTarget = this.selectedUserPromptsTarget
        this.showDoneButton()
    }

    openNewUserPrompt(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('new_user_prompt')
        this.headlineTarget.innerText = 'New user prompt'
        this.hideDoneButton()
    }

    showSection(id) {
        // Hide all sections first
        ['prompts', 'new_prompt', 'user_prompts', 'new_user_prompt'].forEach((sectionId) => {
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
            // Update the this.activeListTarget with the selected prompt
        }
    }

    deselectPrompt(event) {
        event.preventDefault()
        const promptId = event.currentTarget.dataset.promptId
        this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== promptId).join(',')
        // Update the this.activeListTarget by removing the deselected prompt
    }
}
