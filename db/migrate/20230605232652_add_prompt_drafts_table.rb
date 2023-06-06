class AddPromptDraftsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :prompt_drafts, id: :uuid do |t|
      t.references :prompt, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :text, null: false

      t.timestamps
    end
  end
end
