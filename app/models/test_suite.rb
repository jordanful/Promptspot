class TestSuite < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :test_suite_prompts
  has_many :prompts, through: :test_suite_prompts
  has_many :test_suite_user_prompts
  has_many :user_prompts, through: :test_suite_user_prompts
  has_many :test_runs
  validates :name, presence: true
  validates :archived, inclusion: { in: [true, false] }

  def configured?
    prompts.any? || user_prompts.any?
  end
end
