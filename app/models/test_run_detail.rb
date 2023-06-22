class TestRunDetail < ApplicationRecord
  belongs_to :test_run
  belongs_to :prompt
  belongs_to :prompt_version
  belongs_to :input
  belongs_to :model
  after_create :run_test

  private

  def run_test
    update!(status: 'queued')
    RunTestJob.perform_later(self)
  end

end
