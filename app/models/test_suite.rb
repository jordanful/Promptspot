class TestSuite < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :test_suite_prompts
  has_many :prompts, through: :test_suite_prompts
  has_many :test_suite_inputs
  has_many :inputs, through: :test_suite_inputs
  has_many :test_runs
  validates :name, presence: true
  validates :archived, inclusion: { in: [true, false] }

  def configured?
    prompts.any? || inputs.any?
  end

  def run
    test_run = TestRun.create(test_suite: self, run_time: Time.now, status: 'queued')
    # For each prompt and input combination, create a test run detail
    prompts.each do |prompt|
      inputs.each do |input|
        test_run_detail = TestRunDetail.new(test_run: test_run, status: 'queued')
        test_run_detail.prompt = prompt
        test_run_detail.input = input
        test_run_detail.test_suite = self
        test_run_detail.save
      end
    end
    # Return the test run so we can redirect to it
    test_run
  end
end
