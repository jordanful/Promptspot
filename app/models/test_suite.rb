class TestSuite < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_many :test_suite_prompts
  has_many :prompts, through: :test_suite_prompts
  has_many :test_suite_contexts
  has_many :contexts, through: :test_suite_contexts
  has_many :test_runs
  has_many :test_suite_models
  has_many :models, through: :test_suite_models
  validates :name, presence: true
  validates :mode, inclusion: { in: %w[completion chat code image] }
  validates :archived, inclusion: { in: [true, false] }

  def configured?
    prompts.any? || contexts.any?
  end

  def clone
    new_test_suite = dup
    new_test_suite.name = "#{name} (copy)"
    new_test_suite.save!
    prompts.each do |prompt|
      new_test_suite.prompts << prompt
    end
    contexts.each do |context|
      new_test_suite.contexts << context
    end
    models.each do |model|
      new_test_suite.models << model
    end
    new_test_suite
  end

  def archive
    self.archived = true
    self.save!
  end

  def unarchive
    self.archived = false
    self.save!
  end

  def run
    TestRun.create(
      test_suite_id: id,
      status: 'running',
      run_time: Time.now
    )
  end
end
