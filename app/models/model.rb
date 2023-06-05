class Model < ApplicationRecord
  belongs_to :model_provider
  validates :name, presence: true
  validates :enabled, inclusion: { in: [true, false] }

end
