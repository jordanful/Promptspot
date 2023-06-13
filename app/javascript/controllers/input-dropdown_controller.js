import {Controller} from "stimulus"

export default class extends Controller {
    static targets = ["menu", "value"];

    // Add the initialize method to call updateTable on load
    initialize() {
        this.updateTable();
    }

    select(event) {
        // Update value target with the selected input's id
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
        // Retrieve the selected input's id
        const inputId = this.valueTarget.value;

        // Retrieve all table rows
        const rows = document.querySelectorAll("#tableByInput tbody tr");

        // Loop over each row
        rows.forEach(row => {
            // Retrieve the row's data-input-id
            const rowInputId = row.dataset.inputId;

            // Show the row if its input id matches the selected input id, otherwise hide it
            row.style.display = (rowInputId === inputId) ? "table-row" : "none";
        });
    }
}
