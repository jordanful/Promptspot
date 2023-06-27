import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "selected", "value"]

    static values = {defaultInputId: String}


    connect() {
        document.addEventListener('click', this.clickOutside.bind(this));
        if (!this.valueTarget.value) {
            this.valueTarget.value = this.defaultInputIdValue;
        }
    }

    disconnect() {
        document.removeEventListener('click', this.clickOutside.bind(this));
    }

    showMenu(event) {
        event.stopPropagation();
        this.menuTarget.classList.remove('hidden');
    }

    select(event) {
        let inputId = event.currentTarget.dataset.id;
        let inputTitle = event.currentTarget.querySelector('.dropdown-item-title').textContent;
        this.valueTarget.value = inputId;
        this.selectedTarget.textContent = inputTitle;
        this.menuTarget.classList.add('hidden');
        this.menuTarget.querySelectorAll('.dropdown-item').forEach(item => {
            item.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
        this.updateOutput();
    }

    updateOutput() {
        let inputId = this.valueTarget.value;
        document.querySelectorAll(`.output`).forEach(outputDiv => {
            outputDiv.style.display = outputDiv.id === `output${inputId}` ? 'flex' : 'none';
        });
    }

    clickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.add('hidden');
        }
    }
}
