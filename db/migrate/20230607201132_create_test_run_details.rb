class CreateTestRunDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :test_run_details, id: :uuid do |t|
      t.uuid :test_run_id
      t.uuid :prompt_id
      t.uuid :user_prompt_id
      t.string :output

      t.timestamps
    end
  end
end
