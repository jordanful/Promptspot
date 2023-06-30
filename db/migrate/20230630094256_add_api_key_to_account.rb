class AddApiKeyToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :api_key, :string
  end
end
