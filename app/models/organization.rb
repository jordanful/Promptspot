class Organization < ApplicationRecord
  has_many :accounts, dependent: :destroy
  validates :billing_email, presence: true
  validates :timezone, presence: true
end
