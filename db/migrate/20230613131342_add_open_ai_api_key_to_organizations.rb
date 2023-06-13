class AddOpenAiApiKeyToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :open_ai_api_key, :string
  end
end
