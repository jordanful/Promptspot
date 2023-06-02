class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts, id: :uuid do |t|
      t.string :status
      t.uuid :latest_prompt_text_id
      t.uuid :account_id

      t.timestamps
    end
  end
end
