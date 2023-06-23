class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account
  has_many :test_suites
  before_validation :create_organization_and_account, on: :create
  validates :account_id, presence: true
  validates :email, presence: true
  validates :password, presence: true

  def display_name
    "#{first_name} #{last_name}" || email
  end

  private

  def create_organization_and_account
    return if account_id.present?

    ActiveRecord::Base.transaction do
      organization = Organization.create!(billing_email: email)
      account = Account.create!(organization_id: organization.id)
      self.account_id = account.id
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "There was an error creating the organization and account: #{e.message}")
    throw(:abort)
  end

end
