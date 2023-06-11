class CreateTestSuiteModels < ActiveRecord::Migration[7.0]
  def change
    create_table :test_suite_models, id: :uuid do |t|
      t.uuid :test_suite_id
      t.uuid :model_id

      t.timestamps
    end
  end
end
