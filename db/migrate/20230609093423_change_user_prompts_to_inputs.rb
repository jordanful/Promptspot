class ChangeUserPromptsToInputs < ActiveRecord::Migration[7.0]
  def change
    rename_column :test_run_details, :user_prompt_id, :input_id
    rename_column :test_suite_inputs, :user_prompt_id, :input_id
  end
end
