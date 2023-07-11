import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "selected", "value"]

    static values = {defaultContextId: String}

    connect() {
        document.addEventListener('click', this.clickOutside.bind(this));
        window.addEventListener('tab-switch', this.updateOutput.bind(this));  // Listen to 'tab-switch' event
        if (!this.valueTarget.value) {
            this.valueTarget.value = this.defaultContextIdValue;
        }
    }

    disconnect() {
        document.removeEventListener('click', this.clickOutside.bind(this));
        window.removeEventListener('tab-switch', this.updateOutput.bind(this));
    }

    showMenu(event) {
        event.stopPropagation();
        this.menuTarget.classList.remove('hidden');
    }

    select(event) {
        let contextId = event.currentTarget.dataset.id;
        let contextTitle = event.currentTarget.querySelector('.dropdown-item-title').textContent;
        this.valueTarget.value = contextId;
        this.selectedTarget.textContent = contextTitle;
        this.menuTarget.classList.add('hidden');
        this.menuTarget.querySelectorAll('.dropdown-item').forEach(item => {
            item.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
        this.updateOutput();
    }

    updateOutput() {
        if (event.detail.tab && event.detail.tab !== 'context') return;
        let contextId = this.valueTarget.value;
        document.querySelectorAll(`.output`).forEach(outputDiv => {
            outputDiv.style.display = outputDiv.id === `output${contextId}` ? 'flex' : 'none';
        });
    }

    clickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.add('hidden');
        }
    }
}
