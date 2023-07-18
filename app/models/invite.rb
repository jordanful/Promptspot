class Invite < ApplicationRecord
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User', optional: true
  belongs_to :account

  before_create :generate_token
  before_save :check_user_existence

  validates :email, presence: true, unless: ->(invite) { invite.invitee.present? }
  validates :invitee, presence: true, unless: ->(invite) { invite.email.present? }

  def generate_token
    self.token = SecureRandom.uuid
  end

  def check_user_existence
    user = User.find_by(email: email)
    self.invitee = user if user
  end
end
