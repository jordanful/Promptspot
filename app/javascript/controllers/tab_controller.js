import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["tab", "newPrompt", "savedPrompts"]

    connect() {
        this.initializeTabs();
    }

    initializeTabs() {
        const savedTab = localStorage.getItem('selectedTab') || 'new'

        if (this.savedPromptsTarget.children.length == 0) {
            this.tabTarget.style.display = 'none';
            this.savedPromptsTarget.style.display = 'none';
            localStorage.setItem('selectedTab', 'new') // Set the tab to 'new' by default if there are no saved prompts
        } else {
            if (savedTab === 'new') {
                this.newPromptTarget.style.display = 'block';
                this.savedPromptsTarget.style.display = 'none';
            } else {
                this.newPromptTarget.style.display = 'none';
                this.savedPromptsTarget.style.display = 'block';
            }
            this.setActiveTab(this.tabTargets.find(e => e.dataset.tab === savedTab));
        }
    }

    toggle(event) {
        let target = event.currentTarget;
        this.setActiveTab(target);
        localStorage.setItem('selectedTab', target.dataset.tab) // Save the current tab to local storage

        if (target.dataset.tab === 'new') {
            this.newPromptTarget.style.display = 'block';
            this.savedPromptsTarget.style.display = 'none';
        } else {
            this.newPromptTarget.style.display = 'none';
            this.savedPromptsTarget.style.display = 'block';
        }
    }

    setActiveTab(target) {
        this.tabTargets.forEach(t => {
            t.querySelectorAll('div').forEach(div => {
                if (div === target) {
                    div.classList.remove('bg-slate-100', 'hover:bg-slate-50', 'text-gray-600');
                    div.classList.add('bg-white', 'text-black');
                } else {
                    div.classList.add('bg-slate-100', 'hover:bg-slate-50', 'text-gray-600');
                    div.classList.remove('bg-white', 'text-black');
                }
            });
        });
    }

}
