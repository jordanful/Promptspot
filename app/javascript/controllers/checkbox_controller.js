import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["checkbox"];

    connect() {
        this.checkboxTarget.addEventListener('change', () => {
            if (this.checkboxTarget.checked) {
                fetch('/prompts/archived', {
                    headers: {
                        "Accept": "text/vnd.turbo-stream.html",
                    },
                });
            } else {
                fetch('/prompts', {
                    headers: {
                        "Accept": "text/vnd.turbo-stream.html",
                    },
                });
            }
        });
    }
}
