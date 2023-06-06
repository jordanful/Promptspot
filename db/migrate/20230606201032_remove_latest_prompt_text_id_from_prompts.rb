class RemoveLatestPromptTextIdFromPrompts < ActiveRecord::Migration[7.0]
  def change
    remove_column :prompts, :latest_prompt_text_id, :bigint
  end
end
