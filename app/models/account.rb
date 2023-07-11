class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :test_suites, dependent: :destroy
  has_many :prompts, dependent: :destroy
  has_many :contexts, dependent: :destroy
  has_many :api_keys, dependent: :destroy
  belongs_to :organization
  after_create :create_api_key

  def create_api_key
    APIKey.create!(account_id: id)
  end

end
