class AddStatusToTestRunDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :test_run_details, :status, :string
  end
end
