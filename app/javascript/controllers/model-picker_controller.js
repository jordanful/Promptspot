import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["model", "modelIds"]

    get selectedModelIds() {
        return this.modelIdsTarget.value ? this.modelIdsTarget.value.split(',') : []
    }

    selectModel(event) {
        const modelId = event.currentTarget.dataset.modelId
        const modelInput = this.element.querySelector(`input[data-model-id="${modelId}"]`);

        // Remove 'selected' class from all models
        this.modelTargets.forEach(model => model.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300"))

        // Remove all model input fields
        this.element.querySelectorAll(`input[name="test_suite[model_ids][]"]`).forEach(input => input.remove());

        // Add 'selected' class to the clicked model
        event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300")

        if (!modelInput) {
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
