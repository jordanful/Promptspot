class Organization < ApplicationRecord
  has_many :accounts, dependent: :destroy
end
