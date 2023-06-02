class CreatePromptVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :prompt_versions, id: :uuid do |t|
      t.uuid :prompt_id
      t.uuid :user_id
      t.string :text

      t.timestamps
    end
  end
end
