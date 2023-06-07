import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["tab", "newPrompt", "savedPrompts"]

    connect() {
        if (this.savedPromptsTarget.children.length == 0) {
            this.tabTarget.style.display = 'none';
            this.savedPromptsTarget.style.display = 'none';
        } else {
            this.newPromptTarget.style.display = 'block';
            this.savedPromptsTarget.style.display = 'none';
            this.setActiveTab(this.tabTargets.find(e => e.dataset.tab == 'new'));
        }
    }

    toggle(event) {
        let target = event.currentTarget;
        this.setActiveTab(target);
        if (target.dataset.tab == 'new') {
            this.newPromptTarget.style.display = 'block';
            this.savedPromptsTarget.style.display = 'none';
        } else {
            this.newPromptTarget.style.display = 'none';
            this.savedPromptsTarget.style.display = 'block';
        }
    }

    setActiveTab(target) {
        this.tabTargets.forEach(t => {
            if (t == target) {
                t.classList.remove('bg-slate-100', 'hover:bg-slate-50', 'text-gray-600');
                t.classList.add('bg-white', 'text-black');
            } else {
                t.classList.add('bg-slate-100', 'hover:bg-slate-50', 'text-gray-600');
                t.classList.remove('bg-white', 'text-black');
            }
        });
    }
}
