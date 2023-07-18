class AddEmailToInvites < ActiveRecord::Migration[7.0]
  def change
    add_column :invites, :email, :string
  end
end
