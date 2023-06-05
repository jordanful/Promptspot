class AddVersionNumberToPromptVersions < ActiveRecord::Migration[7.0]
  def change
    add_column :prompt_versions, :version_number, :integer, null: false, default: 1
  end
end
