// app/javascript/controllers/draft_controller.js
import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["textarea", "hidden"];

    updateDraftText(event) {
        const textareaTarget = this.textareaTarget;
        const hiddenTarget = this.hiddenTarget;

        hiddenTarget.value = textareaTarget.value;
    }
}
