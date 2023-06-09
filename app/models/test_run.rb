class TestRun < ApplicationRecord
  belongs_to :test_suite
  has_many :test_run_details

  def check_and_update_status
    if self.test_run_details.where.not(status: ['complete', 'error']).empty?
      self.update!(status: 'complete')
    end
  end
end
