class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :prompts, dependent: :destroy
  belongs_to :organization
end
