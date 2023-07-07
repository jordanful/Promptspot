class AddTestRunModelsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :test_run_models do |t|
      t.references :test_run, null: false, foreign_key: true, type: :uuid
      t.references :model, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
