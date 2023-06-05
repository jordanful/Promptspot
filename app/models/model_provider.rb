class ModelProvider < ApplicationRecord
  has_many :models
  validates :name, presence: true
end
