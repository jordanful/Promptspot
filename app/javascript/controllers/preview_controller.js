import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["output", "input", "spinner", "submitButton", "form", "model", "modal", "overlay", "preview"]

    submitForm(event) {
        event.preventDefault();
        this.beforeSend()
        let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
        let model = this.modelTarget.value;
        let userPrompt = this.inputTarget.value;
        let systemPromptElement = document.getElementById('system-prompt');
        let systemPrompt = systemPromptElement.value;
        let params = new URLSearchParams();
        params.append('system_prompt', systemPrompt);
        params.append('input', input);
        params.append('model', model);

        fetch('/prompts/' + this.formTarget.dataset.previewPromptId + '/version/preview', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-CSRF-Token': csrfToken
            },
            body: params
        })
            .then(response => response.text())
            .then(html => {
                this.outputTarget.innerHTML = html;
                this.openModal();
                this.complete();
            })
            .catch(error => {
                console.log(error);
                this.complete();
            });
    }

    beforeSend() {
        this.submitButtonTarget.disabled = true;
        this.spinnerTarget.classList.remove('hidden');
        this.submitButtonTarget.classList.add('opacity-50');  // Add the class
    }

    complete() {
        this.submitButtonTarget.disabled = false;
        this.spinnerTarget.classList.add('hidden');
        this.submitButtonTarget.classList.remove('opacity-50');  // Remove the class
    }

    openModal() {
        this.modalTarget.classList.remove('hidden');
        this.overlayTarget.classList.remove('hidden');
    }

    closeModal() {
        this.modalTarget.classList.add('hidden');
        this.overlayTarget.classList.add('hidden');
        this.previewTarget.innerHTML = ''; // This will clear the preview panel
    }

    handleOutsideClick(event) {
        if (event.target === this.overlayTarget) {
            this.closeModal();
        }
    }

    connect() {
        this.overlayTarget.addEventListener('click', this.handleOutsideClick.bind(this));
    }

    disconnect() {
        this.overlayTarget.removeEventListener('click', this.handleOutsideClick.bind(this));
    }
}
