class Prompt < ApplicationRecord
  belongs_to :account
  has_many :prompt_versions
  has_many :prompt_drafts
  has_many :test_suite_prompts
  has_many :test_suites, through: :test_suite_prompts
  accepts_nested_attributes_for :prompt_versions, reject_if: :all_blank, allow_destroy: true

  validates :status, presence: true, inclusion: { in: %w(active archived) }

  def archive!
    update!(status: 'archived')
  end

  def unarchive!
    update!(status: 'active')
  end

  def archived?
    status == 'archived'
  end

end