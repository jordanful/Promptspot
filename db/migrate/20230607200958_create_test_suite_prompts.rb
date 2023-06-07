class CreateTestSuitePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :test_suite_prompts, id: :uuid do |t|
      t.uuid :test_suite_id
      t.uuid :prompt_id

      t.timestamps
    end
  end
end
