class AddTimezoneToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :timezone, :string, null: false, default: 'UTC'
  end
end
