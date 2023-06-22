class RenameModelType < ActiveRecord::Migration[7.0]
  def change
    rename_column :models, :type, :model_type
  end
end
