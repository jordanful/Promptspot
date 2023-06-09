class TestRunDetail < ApplicationRecord
  belongs_to :test_run
  belongs_to :prompt
  belongs_to :input
  after_create :run_test

  private

  def run_test
    RunTestJob.perform_later(self)
  end
end
