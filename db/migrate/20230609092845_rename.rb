class Rename < ActiveRecord::Migration[7.0]
  def change
    rename_table :test_suite_user_prompts, :test_suite_inputs
  end
end
