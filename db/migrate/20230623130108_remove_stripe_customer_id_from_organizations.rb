class RemoveStripeCustomerIdFromOrganizations < ActiveRecord::Migration[7.0]
  def change
    remove_column :organizations, :stripe_customer_id, :string
  end
end
