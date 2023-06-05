class CreateModelProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :model_providers, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
