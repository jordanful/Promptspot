class PromptDraft < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
  validates :text, presence: true
end