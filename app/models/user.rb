class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :account_memberships, dependent: :destroy
  has_many :accounts, through: :account_memberships

  has_many :test_suites
  after_create :create_organization_and_account, unless: :skip_account_creation
  validates :email, presence: true
  validates :password, presence: true
  attr_accessor :skip_account_creation

  def display_name
    "#{first_name} #{last_name}" || email
  end

  private

  def create_organization_and_account
    ActiveRecord::Base.transaction do
      organization = Organization.create(billing_email: email)
      account = Account.create(organization_id: organization.id)
      AccountMembership.create(user_id: id, account_id: account.id)
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "There was an error creating the organization and account: #{e.message}")
    throw(:abort)
  end

end
