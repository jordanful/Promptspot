class AddAccountIdAndArchivedToTestSuites < ActiveRecord::Migration[7.0]
  def change
    add_reference :test_suites, :account, type: :uuid, foreign_key: true
    add_column :test_suites, :archived, :boolean, default: false
  end
end
