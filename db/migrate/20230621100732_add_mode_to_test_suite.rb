class AddModeToTestSuite < ActiveRecord::Migration[7.0]
  def change
    add_column :test_suites, :mode, :string
  end
end
