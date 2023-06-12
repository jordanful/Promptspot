class AddPromptVersionToTestRunDetails < ActiveRecord::Migration[7.0]
  def change
    add_reference :test_run_details, :prompt_version, null: false, foreign_key: true, type: :uuid
  end
end
