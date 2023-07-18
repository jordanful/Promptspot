class CreateAccountMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :account_memberships do |t|
      t.uuid :user_id
      t.uuid :account_id
      t.timestamps
    end
  end

end
