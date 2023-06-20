import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["panel", "doneButton", "list", "prompt", "input", "selectedPrompts", "selectedInputs", "headline", "search", "overlay", "newPromptTextArea", "newInputTextArea", "spinner", "form", "inputForm"]

    connect() {
        this.handleClick = this.handleClick.bind(this);
        document.addEventListener('click', this.handleClick);
        this.selectionChanged = false;
        this.inputIds = [];
        this.promptIds = [];
        this.updateInputAndPromptIds();
    }

    updateInputAndPromptIds() {
        this.inputIds = Array.from(this.selectedInputsTarget.getElementsByClassName('pill')).map(pill => pill.dataset.id);
        this.promptIds = Array.from(this.selectedPromptsTarget.getElementsByClassName('pill')).map(pill => pill.dataset.id);
        this.setupRemoveButtons();
        this.updateSelectedPromptsOrInputsView();
        this.createHiddenInputsForForm(this.inputIds, "input");
        this.createHiddenInputsForForm(this.promptIds, "prompt");
    }

    createHiddenInputsForForm(ids, type) {
        ids.forEach(id => {
            const hiddenInput = document.createElement("input");
            hiddenInput.type = "hidden";
            hiddenInput.name = `test_suite[${type}_ids][]`;
            hiddenInput.value = id;
            hiddenInput.id = `hidden-${type}-${id}`; // Add an ID for easier reference later
            this.element.appendChild(hiddenInput);
        });
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
        if (!this.promptIds.includes(promptId)) {
            this.promptIds.push(promptId);
            event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
            if (document.querySelectorAll('[data-prompt-id]').length === 1) {
                this.close(event)
            }

            const prompt = document.createElement("input");
            prompt.type = "hidden";
            prompt.name = "test_suite[prompt_ids][]";
            prompt.value = promptId;
            prompt.id = `hidden-prompt-${promptId}`; // Add an ID for easier reference later
            this.element.appendChild(prompt);
        } else {
            this.promptIds = this.promptIds.filter(id => id !== promptId);
            event.currentTarget.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")

            // Remove the corresponding hidden input
            const hiddenInput = document.querySelector(`#hidden-prompt-${promptId}`);
            if (hiddenInput) {
                hiddenInput.remove();
            }
        }
        this.updateSelectedPromptsOrInputsView()
        this.selectionChanged = true;
    }

    selectInput(event) {
        event.preventDefault()
        const inputId = event.currentTarget.dataset.inputId
        if (!this.inputIds.includes(inputId)) {
            this.inputIds.push(inputId);
            event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")
            if (document.querySelectorAll('[data-input-id]').length === 1) {
                this.close(event)
            }

            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "test_suite[input_ids][]";
            input.value = inputId;
            input.id = `hidden-input-${inputId}`; // Add an ID for easier reference later
            this.element.appendChild(input);
        } else {
            this.inputIds = this.inputIds.filter(id => id !== inputId);
            event.currentTarget.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")

            // Remove the corresponding hidden input
            const hiddenInput = document.querySelector(`#hidden-input-${inputId}`);
            if (hiddenInput) {
                hiddenInput.remove();
            }
        }
        this.updateSelectedPromptsOrInputsView()
        this.selectionChanged = true;
    }


    updateSelectedPromptsOrInputsView() {
        // Clear the lists
        this.selectedPromptsTarget.innerHTML = ''
        this.selectedInputsTarget.innerHTML = ''

        // Add the selected prompts
        this.promptIds.forEach((promptId) => {
            let promptElement = document.querySelector(`[data-prompt-id='${promptId}']`)
            if (promptElement) {
                const title = promptElement.querySelector('.title').innerText;
                this.selectedPromptsTarget.innerHTML += `
                <div class="rounded-lg font-medium bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 shadow-md text-blue-700 py-2 px-3 mb-3 mr-3 flex justify-between items-center pill" data-id="${promptId}">
                    ${title}
                    <span class="pill-remove cursor-pointer ml-2 p-1 text-lg hover:text-blue-900 text-blue-700">✕</span>
                </div>
            `
            } else {
                console.warn(`Prompt element not found for ID: ${promptId}`);
            }
            this.setupRemoveButtons();
        })

        // Add the selected inputs
        this.inputIds.forEach((inputId) => {
            let inputElement = document.querySelector(`[data-input-id='${inputId}']`)
            if (inputElement) {
                const title = inputElement.querySelector('.title').innerText;
                this.selectedInputsTarget.innerHTML += `
               <div class="rounded-lg font-medium bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 shadow-md text-blue-700 py-2 px-3 mb-3 mr-3 flex justify-between items-center pill" data-id="${inputId}">
                    ${title}
                    <span class="pill-remove cursor-pointer ml-2 p-1 text-lg hover:text-blue-900 text-blue-700">✕</span>
                </div>
            `
            } else {
                console.warn(`Input element not found for ID: ${inputId}`);
            }
            this.setupRemoveButtons();
        })
    }


    setupRemoveButtons() {
        const pills = document.querySelectorAll('.pill-remove');
        pills.forEach((removeButton) => {
            // First, remove any existing event listener
            const clonedButton = removeButton.cloneNode(true);
            removeButton.parentNode.replaceChild(clonedButton, removeButton);
            // Then, add a new event listener
            clonedButton.addEventListener('click', (event) => {
                event.stopPropagation();
                const pill = event.target.parentElement;
                const idToRemove = pill.dataset.id;
                let panelElement;

                if (this.selectedPromptsTarget.contains(pill)) {
                    this.activeListTarget = this.selectedPromptsTarget;
                    this.promptIds = this.promptIds.filter(id => id !== idToRemove);
                    const hiddenInput = document.querySelector(`#hidden-prompt-${idToRemove}`);
                    if (hiddenInput) {
                        hiddenInput.remove();
                    }
                    // Find the corresponding element in the panel and remove selection classes
                    panelElement = document.querySelector(`[data-prompt-id='${idToRemove}']`);
                } else if (this.selectedInputsTarget.contains(pill)) {
                    this.activeListTarget = this.selectedInputsTarget;
                    this.inputIds = this.inputIds.filter(id => id !== idToRemove);
                    const hiddenInput = document.querySelector(`#hidden-input-${idToRemove}`);
                    if (hiddenInput) {
                        hiddenInput.remove();
                    }
                    // Find the corresponding element in the panel and remove selection classes
                    panelElement = document.querySelector(`[data-input-id='${idToRemove}']`);
                }

                if (panelElement) {
                    panelElement.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300");
                }

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