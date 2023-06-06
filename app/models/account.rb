class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :prompts, dependent: :destroy
  has_many :user_prompts, dependent: :destroy
  belongs_to :organization
end
