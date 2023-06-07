import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["output", "userPrompt", "spinner", "submitButton", "form", "model", "modal", "overlay", "preview"]

    submitForm(event) {
        event.preventDefault();
        this.beforeSend()
        let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
        let model = this.modelTarget.value;
        let userPrompt = this.userPromptTarget.value;
        let systemPromptElement = document.getElementById('system-prompt');
        let systemPrompt = systemPromptElement.value;
        let params = new URLSearchParams();
        params.append('system_prompt', systemPrompt);
        params.append('user_prompt', userPrompt);
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
            .catch(error => console.log(error));
    }

    beforeSend() {
        this.spinnerTarget.classList.remove('hidden');
        this.submitButtonTarget.disabled = true;
    }

    complete() {
        this.spinnerTarget.classList.add('hidden');
        this.submitButtonTarget.disabled = false;
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
