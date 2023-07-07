require 'csv'

class TestRun < ApplicationRecord
  belongs_to :test_suite
  has_many :test_run_models
  has_many :models, through: :test_run_models
  has_many :test_run_details
  validates :archived, inclusion: { in: [true, false] }
  after_create :run
  after_create :save_models

  def check_and_update_status
    if test_run_details.where(status: 'error').any?
      update!(status: 'error')
    else
      update!(status: 'complete')
      # TODO: Send email
    end
    broadcast_status_change
  end

  def archive
    update!(archived: true)
  end

  def unarchive
    update!(archived: false)
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Prompt', 'Input', 'Model', 'Output']
      test_run_details.each do |detail|
        csv << [detail.prompt.current.text, detail.input.text, detail.model.name, detail.output]
      end
    end
  end

  private

  def broadcast_status_change
    Turbo::StreamsChannel.broadcast_replace_to(
      self,
      target: "test_run_#{id}_row",
      partial: "test_runs/row",
      locals: { test_run: self, test_suite: self.test_suite, highlighted: true }
    )
  end

  def run
    update!(status: 'running', run_time: Time.now)
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

  def save_models
    test_suite.models.each do |model|
      TestRunModel.create(test_run_id: id, model_id: model.id)
    end
  end
end
