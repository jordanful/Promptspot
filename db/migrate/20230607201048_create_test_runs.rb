class CreateTestRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :test_runs, id: :uuid do |t|
      t.uuid :test_suite_id
      t.datetime :run_time

      t.timestamps
    end
  end
end
