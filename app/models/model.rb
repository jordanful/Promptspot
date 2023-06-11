class Model < ApplicationRecord
  belongs_to :model_provider
  has_many :test_suites, through: :test_suite_models

  validates :name, presence: true
  validates :enabled, inclusion: { in: [true, false] }

end
