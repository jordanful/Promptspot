class Prompt < ApplicationRecord
  belongs_to :account
  has_many :prompt_versions
  accepts_nested_attributes_for :prompt_versions, reject_if: :all_blank, allow_destroy: true

  validates :status, presence: true, inclusion: { in: %w(active inactive) }

end