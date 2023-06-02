class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :billing_email
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
