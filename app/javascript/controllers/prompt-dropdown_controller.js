import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "value"];

    initialize() {
        // this.updatePrompts();
    }

    connect() {
        document.addEventListener('click', this.clickOutside.bind(this));

    }

    disconnect() {
        document.removeEventListener('click', this.clickOutside.bind(this));
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
        this.valueTarget.value = event.currentTarget.dataset.id;
        this.menuTarget.querySelectorAll('.dropdown-item').forEach(item => {
            item.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
        this.hideMenu();
    }

    hideMenu() {
        this.menuTarget.classList.add('hidden');
    }


    updatePrompts() {
        const promptId = this.valueTarget.value;
        const rows = document.querySelectorAll("#tableByPrompt div");
        rows.forEach(row => {
            const rowPromptId = row.dataset.promptId;
            console.log(rowPromptId, promptId)
            row.style.display = (rowPromptId === promptId) ? "flex" : "hidden";
        });
    }
}
