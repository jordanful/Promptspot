class TestSuite < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :test_suite_prompts
  has_many :prompts, through: :test_suite_prompts
  has_many :test_suite_inputs
  has_many :inputs, through: :test_suite_inputs
  has_many :test_runs
  has_many :test_suite_models
  has_many :models, through: :test_suite_models
  validates :name, presence: true
  validates :archived, inclusion: { in: [true, false] }

  def configured?
    prompts.any? || inputs.any?
  end
end
