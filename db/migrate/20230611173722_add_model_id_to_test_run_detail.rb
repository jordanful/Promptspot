class AddModelIdToTestRunDetail < ActiveRecord::Migration[7.0]
  def change
    add_column :test_run_details, :model_id, :uuid
  end
end
