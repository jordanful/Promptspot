import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["textarea"];
    static values = {promptId: String}

    saveDraft(event) {
        event.preventDefault();

        const draftText = this.textareaTarget.value;

        // Create a new FormData object
        let formData = new FormData();

        // Append only the data you need
        formData.append('text', draftText);

        // Perform an AJAX request to save the draft
        fetch(`/prompts/${this.promptIdValue}/create_draft`, {
            method: 'POST',
            headers: {
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: formData
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
