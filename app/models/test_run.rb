class TestRun < ApplicationRecord
  belongs_to :test_suite
  has_many :test_run_details
  after_create :run

  def check_and_update_status
    if self.test_run_details.where.not(status: ['complete', 'error']).empty?
      self.update!(status: 'complete')
      # TODO: Send email
    end
  end

  private

  def run
    self.update!(status: 'running', run_time: Time.now)
    test_suite.prompts.each do |prompt|
      test_suite.inputs.each do |input|
        test_suite.models.each do |model|
          TestRunDetail.create(
            test_run_id: id,
            status: 'queued',
            prompt: prompt,
            prompt_version: prompt.current,
            input: input,
            model: model
          )
        end
      end
    end
  end
end
