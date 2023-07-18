class RemoveAccountIdFromUsers < ActiveRecord::Migration[7.0]
  def change
    User.all.each do |user|
      if user.account_id
        user.account_memberships.create!(account_id: user.account_id)
      end
    end
    remove_column :users, :account_id, :uuid
  end
end
