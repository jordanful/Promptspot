class CreateUserPrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_prompts, id: :uuid do |t|
      t.string :text
      t.uuid :account_id
      t.uuid :user_id

      t.timestamps
    end
  end
end
