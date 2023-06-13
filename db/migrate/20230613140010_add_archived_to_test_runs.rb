class AddArchivedToTestRuns < ActiveRecord::Migration[7.0]
  def change
    add_column :test_runs, :archived, :boolean, default: false
  end
end
