import {Controller} from "stimulus";

export default class extends Controller {
    static targets = ["theme"];

    connect() {
        this.loadTheme();
    }

    changeTheme() {
        const theme = this.themeTarget.classList.contains("dark") ? "light" : "dark";
        this.themeTarget.classList.toggle("dark", theme === "dark");
        localStorage.theme = theme;
        this.updateTheme();
    }

    loadTheme() {
        const theme = localStorage.theme || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
        this.themeTarget.classList.toggle("dark", theme === "dark");
        this.updateTheme();
    }


    updateTheme() {
        const theme = this.themeTarget.dataset.theme;
        document.documentElement.classList.remove('dark', 'light');
        document.documentElement.classList.add(theme);
    }
}
