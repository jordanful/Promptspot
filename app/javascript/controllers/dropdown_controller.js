import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "value", "button"]

    connect() {
        this.menuTarget.style.display = "none";

        document.addEventListener('click', (event) => {
            if (!this.element.contains(event.target)) {
                this.menuTarget.style.display = "none";
            }
        });
    }

    toggle(event) {
        event.preventDefault();
        this.menuTarget.style.display = this.menuTarget.style.display === "none" ? "block" : "none";
    }

    select(event) {
        event.preventDefault();
        let item = event.currentTarget;
        let title = item.querySelector('.dropdown-item-title').innerHTML;
        this.buttonTarget.querySelector('.dropdown-text').innerHTML = title;
        this.valueTarget.value = item.dataset.id;
        this.menuTarget.style.display = "none";
    }
}
