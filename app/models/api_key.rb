class APIKey < ApplicationRecord
  belongs_to :account
  before_validation :generate_api_key
  validates :key, presence: true, uniqueness: true, length: { is: 64 }
  scope :active, -> { where(status: :active) }
  scope :inactive, -> { where(status: :inactive) }

  def generate_api_key
    self.key = SecureRandom.hex(32)
  end

  def deactivate
    update!(status: :inactive)
  end
end
