class CreateInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :invites, id: :uuid do |t|
      t.references :inviter, null: false, type: :uuid, foreign_key: { to_table: :users }
      t.references :invitee, type: :uuid, foreign_key: { to_table: :users }
      t.references :account, null: false, type: :uuid, foreign_key: true
      t.string :token
      t.boolean :accepted

      t.timestamps
    end
  end
end
