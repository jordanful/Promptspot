import {Controller} from "stimulus"

export default class extends Controller {
    connect() {
        setTimeout(() => {
            this.element.classList.remove('highlight');
        }, 3000);
    }
}
