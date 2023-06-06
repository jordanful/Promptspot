class AddTitleToUserPrompt < ActiveRecord::Migration[7.0]
  def change
    add_column :user_prompts, :title, :string
  end
end
