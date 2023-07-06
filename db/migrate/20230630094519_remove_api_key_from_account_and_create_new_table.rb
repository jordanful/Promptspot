class RemoveAPIKeyFromAccountAndCreateNewTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :api_key, :string
    create_table :api_keys do |t|
      t.string :key
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :status, default: :active, null: false
      t.timestamps
    end
  end
end
