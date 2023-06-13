class RemoveDuplicateOpenAiKeyColumnFromOrganizations < ActiveRecord::Migration[7.0]
  def change
    remove_column :organizations, :open_ai_api_key
  end
end
