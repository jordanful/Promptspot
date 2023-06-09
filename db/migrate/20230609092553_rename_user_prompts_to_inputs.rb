class RenameUserPromptsToInputs < ActiveRecord::Migration[7.0]
  def change
    rename_table :user_prompts, :inputs
  end
end
