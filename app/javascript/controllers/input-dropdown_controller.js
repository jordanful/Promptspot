import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "selected", "value"]

    connect() {
        document.addEventListener('click', this.clickOutside.bind(this));
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
    }

    clickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.add('hidden');
        }
    }
}
