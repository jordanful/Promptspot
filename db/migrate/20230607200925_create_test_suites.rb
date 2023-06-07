class CreateTestSuites < ActiveRecord::Migration[7.0]
  def change
    create_table :test_suites, id: :uuid do |t|
      t.string :name
      t.uuid :user_id

      t.timestamps
    end
  end
end
