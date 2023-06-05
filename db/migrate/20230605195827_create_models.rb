class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :models, id: :uuid do |t|
      t.uuid :model_provider_id
      t.string :name
      t.boolean :enabled

      t.timestamps
    end
  end
end
