class InviteMailer < ApplicationMailer
  default from: 'no-reply@promptspot.com'

  def invitation_email(invite)
    @invite = invite
    @url = new_user_registration_url(invitation_token: @invite.token)
    mail(to: @invite.email, subject: 'You have been invited to PromptSpot')
  end
end
