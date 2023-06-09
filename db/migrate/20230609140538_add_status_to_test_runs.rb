class AddStatusToTestRuns < ActiveRecord::Migration[7.0]
  def change
    add_column :test_runs, :status, :string
  end
end
