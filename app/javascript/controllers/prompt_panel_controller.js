import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["panel", "doneButton", "list", "prompt", "context", "selectedPrompts", "selectedContexts", "headline", "search", "overlay", "newPromptTextArea", "newContextTextArea", "spinner", "form", "contextForm", "runNow"]

    connect() {
        this.handleClick = this.handleClick.bind(this);
        document.addEventListener('click', this.handleClick);
        this.selectionChanged = false;
        this.contextIds = [];
        this.promptIds = [];
        this.updateContextAndPromptIds();
    }

    updateContextAndPromptIds() {
        this.contextIds = Array.from(this.selectedContextsTarget.getElementsByClassName('pill')).map(pill => pill.dataset.id);
        this.promptIds = Array.from(this.selectedPromptsTarget.getElementsByClassName('pill')).map(pill => pill.dataset.id);
        this.setupRemoveButtons();
        this.updateSelectedPromptsOrContextsView();
        this.createHiddenInputsForForm(this.contextIds, "context");
        this.createHiddenInputsForForm(this.promptIds, "prompt");
    }

    createHiddenInputsForForm(ids, type) {
        ids.forEach(id => {
            const hiddenInput = document.createElement("input");
            hiddenInput.type = "hidden";
            hiddenInput.name = `test_suite[${type}_ids][]`;
            hiddenInput.value = id;
            hiddenInput.id = `hidden-${type}-${id}`;
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

    openContext(event) {
        event.preventDefault()
        event.stopPropagation()
        this.activeType = 'context'
        this.activeSection = document.getElementById('contexts')
        this.showSection('contexts')
        this.headlineTarget.innerText = 'Select one or more contexts'
        this.activeListTarget = this.selectedContextsTarget
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
        this.activeListTarget = this.selectedPromptsTarget
    }


    openNewContext(event) {
        event.preventDefault()
        event.stopPropagation()
        this.showSection('new_context')
        this.headlineTarget.innerText = 'New context'
        this.newContextTextAreaTarget.focus()
        this.hideDoneButton()
        this.activeType = 'context'
        this.activeSection = document.getElementById('contexts')
        this.activeListTarget = this.selectedContextsTarget
    }

    showSection(id) {
        // Hide all sections first
        ['prompts', 'new_prompt', 'contexts', 'new_context'].forEach((sectionId) => {
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
        if (this.selectionChanged) {
            this.updateSelectedPromptsOrContextsView()
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
            event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300", "dark:text-white", "dark:border-slate-600", "dark:from-slate-900", "dark:to-slate-800")
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
            event.currentTarget.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "dark:text-white", "border-blue-300", "dark:border-slate-600", "dark:from-slate-900", "dark:to-slate-800", "dark:border-slate-600")

            // Remove the corresponding hidden input
            const hiddenInput = document.querySelector(`#hidden-prompt-${promptId}`);
            if (hiddenInput) {
                hiddenInput.remove();
            }
        }
        this.updateSelectedPromptsOrContextsView()
        this.selectionChanged = true;
    }

    selectContext(event) {
        event.preventDefault()
        const contextId = event.currentTarget.dataset.contextId
        if (!this.contextIds.includes(contextId)) {
            this.contextIds.push(contextId);
            event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "dark:text-white", "border-blue-300", "dark:border-slate-600", "dark:from-slate-900", "dark:to-slate-800", "dark:border-slate-600")
            if (document.querySelectorAll('[data-context-id]').length === 1) {
                this.close(event)
            }

            const context = document.createElement("input");
            context.type = "hidden";
            context.name = "test_suite[context_ids][]";
            context.value = contextId;
            context.id = `hidden-input-${contextId}`; // Add an ID for easier reference later
            this.element.appendChild(context);
        } else {
            this.contextIds = this.contextIds.filter(id => id !== contextId);
            event.currentTarget.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "dark:text-white", "border-blue-300", "dark:border-slate-600", "dark:from-slate-900", "dark:to-slate-800", "dark:border-slate-600")

            // Remove the corresponding hidden input
            const hiddenInput = document.querySelector(`#hidden-input-${contextId}`);
            if (hiddenInput) {
                hiddenInput.remove();
            }
        }
        this.updateSelectedPromptsOrContextsView()
        this.selectionChanged = true;
    }


    updateSelectedPromptsOrContextsView() {
        // Clear the lists
        this.selectedPromptsTarget.innerHTML = ''
        this.selectedContextsTarget.innerHTML = ''

        // Add the selected prompts
        this.promptIds.forEach((promptId) => {
            let promptElement = document.querySelector(`[data-prompt-id='${promptId}']`)
            if (promptElement) {
                const title = promptElement.querySelector('.title').innerText;
                this.selectedPromptsTarget.innerHTML += `
                <div class="rounded-lg font-medium dark:border-slate-600 dark:from-slate-900 dark:to-slate-800 dark:text-white bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 shadow-md text-blue-700 py-2 px-3 mb-3 mr-3 flex justify-between items-center pill" data-id="${promptId}">
                    ${title}
                    <span class="pill-remove cursor-pointer ml-2 p-1 text-lg hover:text-blue-900 dark:text-white text-blue-700">✕</span>
                </div>
            `
            } else {
                console.warn(`Prompt element not found for ID: ${promptId}`);
            }
            this.setupRemoveButtons();
        })

        // Add the selected contexts
        this.contextIds.forEach((contextId) => {
            let contextElement = document.querySelector(`[data-context-id='${contextId}']`)
            if (contextElement) {
                const title = contextElement.querySelector('.title').innerText;
                this.selectedContextsTarget.innerHTML += `
               <div class="rounded-lg font-medium dark:border-slate-600 dark:from-slate-900 dark:to-slate-800 dark:text-white bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 shadow-md text-blue-700 py-2 px-3 mb-3 mr-3 flex justify-between items-center pill" data-id="${contextId}">
                    ${title}
                    <span class="pill-remove cursor-pointer ml-2 p-1 text-lg hover:text-blue-900 dark:text-white text-blue-700">✕</span>
                </div>
            `
            } else {
                console.warn(`Context element not found for ID: ${contextId}`);
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
                } else if (this.selectedContextsTarget.contains(pill)) {
                    this.activeListTarget = this.selectedContextsTarget;
                    this.contextIds = this.contextIds.filter(id => id !== idToRemove);
                    const hiddenInput = document.querySelector(`#hidden-context-${idToRemove}`);
                    if (hiddenInput) {
                        hiddenInput.remove();
                    }
                    // Find the corresponding element in the panel and remove selection classes
                    panelElement = document.querySelector(`[data-context-id='${idToRemove}']`);
                }

                if (panelElement) {
                    panelElement.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "dark:text-white", "border-blue-300", "dark:border-slate-600", "dark:from-slate-900", "dark:to-slate-800", "dark:border-slate-600");
                }

                pill.remove();
            });
        });
    }


    reset() {
        this.newPromptTextAreaTarget.value = '';
        this.newContextTextAreaTarget.value = '';
    }

    async createContext(event) {
        event.preventDefault();
        event.stopPropagation();

        const newContextText = this.newContextTextAreaTarget.value;
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        this.spinnerTarget.style.display = 'block';
        this.contextFormTarget.disabled = true;

        const response = await fetch('/contexts', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRF-Token': csrfToken,
            },
            body: JSON.stringify({
                context: {
                    text: newContextText
                }
            }),
        });

        const responseData = await response.json();

        // Hide spinner and re-enable form
        this.spinnerTarget.style.display = 'none';
        this.contextFormTarget.disabled = false;
        if (response.ok) {
            this.activeSection.insertAdjacentHTML('beforeend', `
            <div class="bg-gradient-to-b from-blue-200 to-blue-50 border border-blue-300 rounded-md p-4 cursor-pointer mb-4"
                data-action="click->prompt-panel#selectContext"
                data-prompt-panel-target="context"
                data-context-id="${responseData.id}">
            <p class="text-base mb-2 title">${responseData.title}</p>
            <p class="text-gray-600 text-sm font-mono">${responseData.text}</p>
            </div>
        `);
            this.contextIds.push(responseData.id);
            this.createHiddenContextsForForm([responseData.id], "context");
            this.showSection('contexts');
            this.updateSelectedPromptsOrContextsView();
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
            this.activeSection.insertAdjacentHTML('beforeend', `
            <div class="bg-gradient-to-b from-blue-200 to-blue-50 dark:border-slate-600 dark:from-slate-900 dark:to-slate-800 dark:text-white border border-blue-300 rounded-md p-4 cursor-pointer mb-4 rounded-md p-4 cursor-pointer mb-4"
                data-action="click->prompt-panel#selectPrompt"
                data-prompt-panel-target="prompt"
                data-prompt-id="${responseData.id}">
            <p class="text-base mb-2 title">${responseData.title}</p>
            <p class="text-gray-600 text-sm font-mono">${responseData.text}</p>
            </div>
        `);
            this.promptIds.push(responseData.id);
            this.createHiddenInputsForForm([responseData.id], "prompt");
            this.showSection('prompts');
            this.updateSelectedPromptsOrContextsView();
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

    runNow(event) {
        this.runNowTarget.value = "true"
    }
}