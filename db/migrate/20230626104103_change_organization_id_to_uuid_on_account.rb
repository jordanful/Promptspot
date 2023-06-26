class ChangeOrganizationIdToUuidOnAccount < ActiveRecord::Migration[7.0]
  def change
    change_column :accounts, :organization_id, :uuid, using: 'organization_id::uuid'
  end
end
