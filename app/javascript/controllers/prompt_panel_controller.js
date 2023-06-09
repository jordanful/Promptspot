import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["panel", "doneButton", "list", "prompt", "input", "promptIds", "inputIds", "selectedPrompts", "selectedInputs", "headline", "search", "overlay", "newPromptTextArea", "spinner", "form"]

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
        this.activeType = 'prompt'
        this.activeSection = document.getElementById('prompts')
        this.showSection('prompts')
        this.headlineTarget.innerText = 'Select one or more prompts'
        this.activeTarget = this.promptIdsTarget
        this.activeListTarget = this.selectedPromptsTarget
        this.showDoneButton()
    }

    openInput(event) {
        event.preventDefault()
        event.stopPropagation()
        this.activeType = 'input'
        this.activeSection = document.getElementById('inputs')
        this.showSection('inputs')
        this.headlineTarget.innerText = 'Select one or more inputs'
        this.activeTarget = this.inputIdsTarget
        this.activeListTarget = this.selectedInputsTarget
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
        if (this.activeTarget) {
            this.updateSelectedPromptsOrInputsView()
        }
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

            // If this is the only prompt, close the panel
            if (document.querySelectorAll('[data-prompt-id]').length === 1) {
                this.close(event)
            }
        } else {
            this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== promptId).join(',')
            // Remove 'selected' class since this prompt is deselected
            event.currentTarget.classList.remove('selected')
        }
        this.updateSelectedPromptsOrInputsView()
    }

    selectInput(event) {
        event.preventDefault()
        const inputId = event.currentTarget.dataset.inputId
        if (!this.activeTarget.value.split(',').includes(inputId)) {
            this.activeTarget.value = this.activeTarget.value ? `${this.activeTarget.value},${inputId}` : inputId
            // Add 'selected' class to highlight this input
            event.currentTarget.classList.add('selected')

            // If this is the only input, close the panel
            if (document.querySelectorAll('[data-input-id]').length === 1) {
                this.close(event)
            }
        } else {
            this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== inputId).join(',')
            // Remove 'selected' class since this input is deselected
            event.currentTarget.classList.remove('selected')
        }
        this.updateSelectedPromptsOrInputsView()
    }


    updateSelectedPromptsOrInputsView() {
        this.activeListTarget.innerHTML = ''
        const ids = this.activeTarget.value.split(',')
        ids.forEach((id) => {
            const selectedElement = document.querySelector(`[data-${this.activeTarget.id === 'prompt_ids' ? 'prompt' : 'input'}-id="${id}"]`)
            if (selectedElement) {
                const title = selectedElement.querySelector('.title').innerText
                this.activeListTarget.innerHTML += `
            <div class="rounded-lg bg-white border border-blue-200 text-gray-700 py-2 px-3 mb-3 mr-3 flex justify-between items-center pill" data-id="${id}">
                ${title}
                <span class="pill-remove cursor-pointer ml-2 p-1 text-lg text-red-500">✕</span>
            </div>
        `
            } else {
                console.log(`Selected element not found for id: ${id}`)
            }
        })
        this.setupRemoveButtons()
    }


    setupRemoveButtons() {
        this.activeListTarget.querySelectorAll('.pill-remove').forEach((removeButton) => {
            removeButton.addEventListener('click', (event) => {
                event.stopPropagation()
                const pill = event.target.parentElement
                const idToRemove = pill.dataset.id
                this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== idToRemove).join(',')

                // Update selected state in the panel
                const selectedElement = document.querySelector(`[data-${this.activeTarget.id === 'prompt_ids' ? 'prompt' : 'input'}-id="${idToRemove}"]`)
                if (selectedElement) {
                    selectedElement.classList.remove('selected')
                }

                pill.remove()
            })
        })
    }

    async createPrompt(event) {
        event.preventDefault();
        event.stopPropagation();

        const newPromptText = this.newPromptTextAreaTarget.value;

        // Get CSRF token
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        // Show spinner and disable form
        this.spinnerTarget.style.display = 'block';
        this.formTarget.disabled = true;

        const response = await fetch('/prompts', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRF-Token': csrfToken,
            },
            body: JSON.stringify({
                prompt: {
                    status: 'active',
                    prompt_versions_attributes: [
                        {text: newPromptText}
                    ]
                }
            }),
        });

        const responseData = await response.json();

        // Hide spinner and re-enable form
        this.spinnerTarget.style.display = 'none';
        this.formTarget.disabled = false;

        if (response.ok) {
            // The prompt has been created successfully
            // Now add it to the list of prompts and select it
            this.activeTarget.value = responseData.id;
            this.activeSectionTarget.insertAdjacentHTML('beforeend', `
            <div class="border-gray-300 border rounded-md p-4 cursor-pointer mb-4 hover:bg-blue-50 selected"
                data-action="click->prompt-panel#selectPrompt"
                data-prompt-panel-target="prompt"
                data-prompt-id="${responseData.id}">
            <p class="text-base mb-2 title">${responseData.title}</p>
            <p class="text-gray-600 text-sm font-mono">${responseData.text}</p>
            </div>
        `);
            this.showSection('prompts');
            this.updateSelectedPromptsOrInputsView();
            this.close(event)
        } else {
            // An error occurred, show the error messages
            this.activeSectionTarget.insertAdjacentHTML('beforeend', `
            <div class="alert alert-danger">
            <p>${responseData.error}</p>
            </div>
        `);

        }


    }

    async createPrompt(event) {
        const newPromptText = this.newPromptTextAreaTarget.value;

        // Get CSRF token
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        const response = await fetch('/prompts', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRF-Token': csrfToken,
            },
            body: JSON.stringify({
                prompt: {
                    status: 'active',
                    prompt_versions_attributes: [
                        {text: newPromptText}
                    ]
                }
            }),
        });

        const responseData = await response.json();

        if (response.ok) {
            // The prompt has been created successfully
            // Now add it to the list of prompts and select it
            this.promptIdsTarget.value = responseData.id;
            this.listTarget.insertAdjacentHTML('beforeend', `
            <div class="border-gray-300 border rounded-md p-4 cursor-pointer mb-4 hover:bg-blue-50 selected"
                data-action="click->prompt-panel#selectPrompt"
                data-prompt-panel-target="prompt"
                data-prompt-id="${responseData.id}">
            <p class="text-base mb-2 title">${responseData.title}</p>
            <p class="text-gray-600 text-sm font-mono">${responseData.text}</p>
            </div>
        `);
            this.showSection('prompts');
            this.updateSelectedPromptsOrInputsView();
            this.close(event);
        } else {
            // An error occurred, show the error messages
            this.listTarget.insertAdjacentHTML('beforeend', `
            <div class="alert alert-danger">
            <p>${responseData.error}</p>
            </div>
        `);
        }
    }

}
