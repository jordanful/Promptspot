import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["textarea"];
    static values = {promptId: String, draftId: String}


    saveDraft(event) {
        event.preventDefault();

        const draftText = this.textareaTarget.value;

        let formData = new FormData();
        formData.append('text', draftText);

        fetch(`/prompts/${this.promptIdValue}/create_draft`, {
            method: 'POST',
            headers: {
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    // Handle error
                    console.error('Failed to save the draft', data.error);
                } else {
                    // Draft saved successfully
                    console.log('Draft saved!');
                    window.location.href = data.location; // Redirect to the returned location
                }
            })
            .catch(error => {
                console.error('An error occurred while saving the draft', error);
            });
    }

    deleteDraft(event) {
        event.preventDefault();
        fetch(`/prompts/${this.promptIdValue}/draft/${this.draftIdValue}`, {
            method: 'DELETE',
            headers: {
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    console.error('Failed to delete the draft', data.error);
                } else {
                    console.log('Draft deleted!');
                    window.location.href = data.location;
                }
            })
            .catch(error => {
                    console.error('An error occurred while deleting the draft', error);
                }
            );

    }

}
