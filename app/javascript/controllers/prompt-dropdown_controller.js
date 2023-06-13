import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "value"];

    // Add the initialize method to call updateTable on load
    initialize() {
        this.updateTable();
    }

    select(event) {
        // Update value target with the selected prompt's id
        this.valueTarget.value = event.currentTarget.dataset.id;

        // Remove 'selected' class from all items
        this.menuTarget.querySelectorAll('.dropdown-item').forEach(item => {
            item.classList.remove('selected');
        });

        // Add 'selected' class to the clicked item
        event.currentTarget.classList.add('selected');

        // Call the function to update the table
        this.updateTable();
    }

    updateTable() {
        // Retrieve the selected prompt's id
        const promptId = this.valueTarget.value;

        // Retrieve all table rows
        const rows = document.querySelectorAll("#tableByPrompt tbody tr");

        // Loop over each row
        rows.forEach(row => {
            // Retrieve the row's data-prompt-id
            const rowPromptId = row.dataset.promptId;

            // Show the row if its prompt id matches the selected prompt id, otherwise hide it
            row.style.display = (rowPromptId === promptId) ? "table-row" : "none";
        });
    }
}
