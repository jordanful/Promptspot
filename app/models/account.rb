class Account < ApplicationRecord
  has_many :account_memberships, dependent: :destroy
  has_many :users, through: :account_memberships
  has_many :test_suites, dependent: :destroy
  has_many :prompts, dependent: :destroy
  has_many :inputs, dependent: :destroy
  has_many :api_keys, dependent: :destroy
  belongs_to :organization
  after_create :create_api_key

  def create_api_key
    APIKey.create!(account_id: id)
  end

end
