class RemoveAccountNonNullConstraintOnUser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :account_id, true
  end
end
