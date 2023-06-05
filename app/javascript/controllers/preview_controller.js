import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["output", "userPrompt", "spinner", "submitButton", "form"]

    connect() {
        this.formTarget.addEventListener('submit', event => this.submitForm(event));
    }

    submitForm(event) {
        event.preventDefault();

        this.beforeSend()


        let userPrompt = this.userPromptTarget.value;
        let systemPromptElement = document.getElementById('system-prompt');
        let systemPrompt = systemPromptElement.value;
        let params = new URLSearchParams();
        params.append('system_prompt', systemPrompt);
        params.append('user_prompt', userPrompt);

        fetch(this.data.get('url'), {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params
        })
            .then(response => response.text())
            .then(html => {
                this.outputTarget.innerHTML = html;
                this.complete()
            });
    }

    beforeSend() {
        this.spinnerTarget.classList.remove('hidden');
        this.submitButtonTarget.disabled = true;
    }

    complete() {
        this.spinnerTarget.classList.add('hidden');
        this.submitButtonTarget.disabled = false;
    }


}
