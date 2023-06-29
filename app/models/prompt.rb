class Prompt < ApplicationRecord
  belongs_to :account
  has_many :prompt_versions, dependent: :destroy
  has_many :prompt_drafts, dependent: :destroy
  has_many :test_suite_prompts
  has_many :test_suites, through: :test_suite_prompts
  accepts_nested_attributes_for :prompt_versions, reject_if: :all_blank, allow_destroy: true
  scope :active, -> { where(status: 'active') }
  scope :archived, -> { where(status: 'archived') }
  scope :order_by_recently_updated, -> {
    select('prompts.*, MAX(prompt_versions.updated_at) AS max_updated_at')
      .joins(:prompt_versions)
      .group('prompts.id')
      .order('max_updated_at DESC')
  }
  validates :status, presence: true, inclusion: { in: %w(active archived) }

  def current
    prompt_versions.order(version_number: :desc).first
  end

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