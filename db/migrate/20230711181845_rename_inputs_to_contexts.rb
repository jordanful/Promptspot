class RenameInputsToContexts < ActiveRecord::Migration[7.0]
  def change
    rename_table :inputs, :contexts
  end
end
