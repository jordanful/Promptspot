import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["panel", "doneButton", "list", "prompt", "input", "promptIds", "inputIds", "selectedPrompts", "selectedInputs", "headline", "search", "overlay", "newPromptTextArea", "newInputTextArea", "spinner", "form", "inputForm"]

    connect() {
        this.handleClick = this.handleClick.bind(this);
        document.addEventListener('click', this.handleClick);
        this.selectionChanged = false;
        this.setupRemoveButtons();
        this.updateSelectedPromptsOrInputsView();
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
        this.activeTarget.value = Array.from(this.activeListTarget.getElementsByClassName('pill')).map(pill => pill.dataset.id).join(',')
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
        this.activeTarget.value = Array.from(this.activeListTarget.getElementsByClassName('pill')).map(pill => pill.dataset.id).join(',')
        this.showDoneButton()
    }


    openNewPrompt(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('new_prompt')
        this.headlineTarget.innerText = 'New prompt'
        this.newPromptTextAreaTarget.focus()
        this.hideDoneButton()
        this.activeType = 'prompt'
        this.activeSection = document.getElementById('prompts')
        this.activeTarget = this.promptIdsTarget
        this.activeListTarget = this.selectedPromptsTarget
    }


    openNewInput(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('new_input')
        this.headlineTarget.innerText = 'New input'
        this.newInputTextAreaTarget.focus()
        this.hideDoneButton()
        this.activeType = 'input'
        this.activeSection = document.getElementById('inputs')
        this.activeTarget = this.inputIdsTarget
        this.activeListTarget = this.selectedInputsTarget
    }

    showSection(id) {
        // Hide all sections first
        ['prompts', 'new_prompt', 'inputs', 'new_input'].forEach((sectionId) => {
            document.getElementById(sectionId).style.display = 'none'
        })

        // Show the specific section
        document.getElementById(id).style.display = 'block'
        console.log(document.getElementById(id))
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
        if (this.activeTarget && this.selectionChanged) {
            this.updateSelectedPromptsOrInputsView()
            this.selectionChanged = false;
        }
        this.overlayTarget.classList.remove('overlay-open')
        this.panelTarget.classList.remove('panel-open')
    }


    selectPrompt(event) {
        event.preventDefault()
        const promptId = event.currentTarget.dataset.promptId
        if (!this.activeTarget.value.split(',').includes(promptId)) {
            this.activeTarget.value = this.activeTarget.value ? `${this.activeTarget.value},${promptId}` : promptId
            event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
            if (document.querySelectorAll('[data-prompt-id]').length === 1) {
                this.close(event)
            }
        } else {
            this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== promptId).join(',')
            event.currentTarget.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
        }
        const selectedIds = this.activeTarget.value.split(',')
        selectedIds.forEach(id => {
            const selectedElement = document.querySelector(`[data-prompt-id="${id}"]`)
            if (selectedElement) {
                selectedElement.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
            }
        })
        this.updateSelectedPromptsOrInputsView()
        this.selectionChanged = true;
    }

    selectInput(event) {
        event.preventDefault()
        const inputId = event.currentTarget.dataset.inputId
        if (!this.activeTarget.value.split(',').includes(inputId)) {
            this.activeTarget.value = this.activeTarget.value ? `${this.activeTarget.value},${inputId}` : inputId
            event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
            if (document.querySelectorAll('[data-input-id]').length === 1) {
                this.close(event)
            }
        } else {
            this.activeTarget.value = this.activeTarget.value.split(',').filter(id => id !== inputId).join(',')
            event.currentTarget.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
        }
        // Make sure to maintain selections when the panel is closed
        const selectedIds = this.activeTarget.value.split(',')
        selectedIds.forEach(id => {
            const selectedElement = document.querySelector(`[data-input-id="${id}"]`)
            if (selectedElement) {
                selectedElement.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
            }
        })

        // Remove existing input_ids hidden inputs
        this.element.querySelectorAll(`input[name="test_suite[input_ids][]"]`).forEach(input => input.remove());

        // Create new hidden inputs for each selected input ID
        selectedIds.forEach(inputId => {
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "test_suite[input_ids][]";
            input.value = inputId;
            this.element.appendChild(input);
        });

        this.updateSelectedPromptsOrInputsView()
        this.selectionChanged = true;
    }


    updateSelectedPromptsOrInputsView() {
        if (this.activeListTarget) {
            this.activeListTarget.innerHTML = '';
            const ids = this.activeTarget.value.split(',');
            ids.forEach((id) => {
                const selectedElement = document.querySelector(`[data-${this.activeTarget.id === 'prompt_ids' ? 'prompt' : 'input'}-id="${id}"]`);
                if (selectedElement) {
                    const title = selectedElement.querySelector('.title').innerText;
                    this.activeListTarget.innerHTML += `
                <div class="rounded-lg font-medium bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 shadow-md text-blue-700 py-2 px-3 mb-3 mr-3 flex justify-between items-center pill" data-id="${id}">
                    ${title}
                    <span class="pill-remove cursor-pointer ml-2 p-1 text-lg hover:text-blue-900 text-blue-700">✕</span>
                </div>
            `;
                }
            });
            this.setupRemoveButtons();
        }
    }


    setupRemoveButtons() {
        const pills = document.querySelectorAll('.pill-remove');
        pills.forEach((removeButton) => {
            removeButton.addEventListener('click', (event) => {
                event.stopPropagation();
                const pill = event.target.parentElement;
                const idToRemove = pill.dataset.id;

                // Get the current active target
                const activeTarget = this.activeListTarget;

                // Update the active target value by removing the ID to be removed
                const updatedValue = activeTarget.value
                    .split(',')
                    .filter((id) => id !== idToRemove)
                    .join(',');

                activeTarget.value = updatedValue;

                // Remove the pill from the active list
                pill.remove();
            });
        });
    }


    reset() {
        this.newPromptTextAreaTarget.value = ''; // clear the textarea
        this.newInputTextAreaTarget.value = ''; // clear the textarea
    }

    async createInput(event) {
        event.preventDefault();
        event.stopPropagation();

        const newInputText = this.newInputTextAreaTarget.value;

        // Get CSRF token
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        // Show spinner and disable form
        this.spinnerTarget.style.display = 'block';
        this.inputFormTarget.disabled = true;

        const response = await fetch('/inputs', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRF-Token': csrfToken,
            },
            body: JSON.stringify({
                input: {
                    text: newInputText
                }
            }),
        });

        const responseData = await response.json();

        // Hide spinner and re-enable form
        this.spinnerTarget.style.display = 'none';
        this.inputFormTarget.disabled = false;
        if (response.ok) {
            this.activeTarget.value = this.activeTarget.value ? `${this.activeTarget.value},${responseData.id}` : responseData.id;

            this.activeSection.insertAdjacentHTML('beforeend', `
            <div class="bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 rounded-md p-4 cursor-pointer mb-4"
                data-action="click->prompt-panel#selectInput"
                data-prompt-panel-target="input"
                data-input-id="${responseData.id}">
            <p class="text-base mb-2 title">${responseData.title}</p>
            <p class="text-gray-600 text-sm font-mono">${responseData.text}</p>
            </div>
        `);
            this.showSection('inputs');
            this.updateSelectedPromptsOrInputsView();
            this.close(event);
            this.reset();
        } else {
            // An error occurred, show the error messages
            this.activeSection.insertAdjacentHTML('beforeend', `
            <div class="alert alert-danger">
            <p>${responseData.error}</p>
            </div>
        `);
        }
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

            this.activeTarget.value = this.activeTarget.value ? `${this.activeTarget.value},${responseData.id}` : responseData.id;
            this.activeSection.insertAdjacentHTML('beforeend', `
            <div class="bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 rounded-md p-4 cursor-pointer mb-4 rounded-md p-4 cursor-pointer mb-4"
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
            this.reset();
        } else {
            // An error occurred, show the error messages
            this.activeSection.insertAdjacentHTML('beforeend', `
            <div class="alert alert-danger">
            <p>${responseData.error}</p>
            </div>
        `);
        }
    }
}