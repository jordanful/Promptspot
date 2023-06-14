import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["model"]

    connect() {
        const selectedModel = this.modelTargets.find((model) => model.classList.contains("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300"));
        if (selectedModel) {
            this.createHiddenInput(selectedModel.dataset.modelId);
        }
    }

    selectModel(event) {
        const modelId = event.currentTarget.dataset.modelId;
        this.modelTargets.forEach(model => model.classList.remove("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300"));
        event.currentTarget.classList.add("bg-gradient-to-b", "from-blue-200", "to-blue-50", "border-blue-300");
        this.createHiddenInput(modelId);
    }

    createHiddenInput(modelId) {
        const oldInput = this.element.querySelector('input[name="test_suite[model_ids][]"]');
        if (oldInput) {
            oldInput.remove();
        }

        const input = document.createElement("input");
        input.type = "hidden";
        input.name = "test_suite[model_ids][]";
        input.value = modelId;
        this.element.appendChild(input);
    }
}
