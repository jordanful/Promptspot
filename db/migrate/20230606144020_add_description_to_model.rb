class AddDescriptionToModel < ActiveRecord::Migration[7.0]
  def change
    add_column :models, :description, :string
  end
end
