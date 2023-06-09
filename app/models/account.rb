class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :test_suites, dependent: :destroy
  has_many :prompts, dependent: :destroy
  has_many :inputs, dependent: :destroy
  belongs_to :organization
end
