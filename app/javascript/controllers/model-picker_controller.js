import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["model", "modelIds"]

    get selectedModelIds() {
        return this.modelIdsTarget.value ? this.modelIdsTarget.value.split(',') : []
    }

    selectModel(event) {
        const modelId = event.currentTarget.dataset.modelId
        const modelInput = this.element.querySelector(`input[data-model-id="${modelId}"]`);

        // Toggle selected class on the clicked model
        event.currentTarget.classList.toggle('selected')

        if (modelInput) {
            // If input already exists for this modelId, remove it
            modelInput.remove();
        } else {
            // Create a new hidden input for this modelId
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "test_suite[model_ids][]";
            input.value = modelId;
            input.dataset.modelId = modelId;
            this.element.appendChild(input);
        }
    }

}
