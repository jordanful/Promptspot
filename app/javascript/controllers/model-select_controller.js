import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["modelSelect"]

    connect() {
        this.loadModel();
    }

    loadModel() {
        const savedModel = localStorage.getItem('selectedModel');
        if (savedModel) {
            this.modelSelectTarget.value = savedModel;
        }
    }

    saveModel() {
        const selectedModel = this.modelSelectTarget.value;
        localStorage.setItem('selectedModel', selectedModel);
    }
}
