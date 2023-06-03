class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account

  before_validation :create_organization_and_account, on: :create

  private

  def create_organization_and_account
    ActiveRecord::Base.transaction do
      organization = Organization.create!(billing_email: self.email)
      account = Account.create!(organization_id: organization.id)
      self.account_id = account.id
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "There was an error creating the organization and account: #{e.message}")
    throw(:abort)
  end
end
