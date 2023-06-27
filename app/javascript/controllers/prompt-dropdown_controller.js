import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "selected", "value"];

    connect() {
        document.addEventListener('click', this.clickOutside.bind(this));
        window.addEventListener('tab-switch', this.updateOutput.bind(this));  // Listen to 'tab-switch' event

        if (!this.valueTarget.value) {
            this.valueTarget.value = this.element.dataset.defaultPromptId;
        }
    }


    disconnect() {
        document.removeEventListener('click', this.clickOutside.bind(this));
        window.removeEventListener('tab-switch', this.updateOutput.bind(this));
    }

    clickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.add('hidden');
        }
    }


    showMenu() {
        this.menuTarget.classList.remove('hidden');
    }

    select(event) {
        let promptId = event.currentTarget.dataset.id;
        let promptTitle = event.currentTarget.querySelector('.dropdown-item-title').textContent;
        this.valueTarget.value = promptId;
        this.selectedTarget.textContent = promptTitle;
        this.menuTarget.classList.add('hidden');
        this.menuTarget.querySelectorAll('.dropdown-item').forEach(item => {
            item.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
        this.updateOutput();
    }

    hideMenu() {
        this.menuTarget.classList.add('hidden');
    }


    updateOutput() {
        if (event.detail.tab && event.detail.tab !== 'prompt') return;
        let promptId = this.valueTarget.value;
        document.querySelectorAll(`.output`).forEach(outputDiv => {
            outputDiv.style.display = outputDiv.id === `output${promptId}` ? 'flex' : 'none';
        });
    }

}
