class CreateTestSuiteUserPrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :test_suite_user_prompts, id: :uuid do |t|
      t.uuid :test_suite_id
      t.uuid :user_prompt_id

      t.timestamps
    end
  end
end
