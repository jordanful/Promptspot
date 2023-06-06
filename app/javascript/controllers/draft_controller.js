// app/javascript/controllers/draft_controller.js

import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["textarea", "hidden"];

    get textareaTarget() {
        return this.targets.find(target => target.dataset.draftTarget === 'textarea');
    }

    get hiddenTarget() {
        return this.targets.find(target => target.dataset.draftTarget === 'hidden');
    }

    connect() {
        this.promptId = this.data.get("promptId");
    }

    saveDraft(event) {
        event.preventDefault();

        const draftText = this.textareaTarget.value;

        // Perform an AJAX request to save the draft
        fetch(`/prompts/${this.promptId}/create_draft`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({draft_text: draftText})
        })
            .then(response => {
                if (response.ok) {
                    // Draft saved successfully
                    console.log('Draft saved!');
                } else {
                    // Handle error
                    console.error('Failed to save the draft');
                }
            })
            .catch(error => {
                console.error('An error occurred while saving the draft', error);
            });
    }
}
