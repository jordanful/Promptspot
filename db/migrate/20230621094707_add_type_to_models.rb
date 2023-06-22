class AddTypeToModels < ActiveRecord::Migration[7.0]

  def change
    add_column :models, :type, :string
  end
end
