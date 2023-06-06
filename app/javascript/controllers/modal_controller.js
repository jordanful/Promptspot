import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["modal", "overlay"]

    connect() {
        document.addEventListener('keyup', this.keyup)
    }

    disconnect() {
        document.removeEventListener('keyup', this.keyup)
    }

    keyup = (event) => {
        if (event.key === "Escape") {
            this.close()
        }
    }

    open() {
        this.modalTarget.classList.remove('hidden');
        this.overlayTarget.classList.remove('hidden');
    }

    close() {
        this.modalTarget.classList.add('hidden');
        this.overlayTarget.classList.add('hidden');
    }
}
