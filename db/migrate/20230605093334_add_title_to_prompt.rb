class AddTitleToPrompt < ActiveRecord::Migration[7.0]
  def change
    add_column :prompts, :title, :string
  end
end
