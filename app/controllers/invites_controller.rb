class InvitesController < ApplicationController
  layout 'accept', only: [:accept]
  before_action :authenticate_user!, only: [:create] # Only authenticated users can create invites

  def create
    @invite = Invite.new(invite_params)
    @invite.inviter = current_user
    @invite.account = @current_account

    user = User.find_by(email: invite_params[:email])

    if user.present?
      if user == current_user
        flash[:alert] = "You can't invite yourself."
        redirect_to account_path(@current_account) and return
      else
        @invite.invitee = user
      end
    else
      @invite.invitee = User.new(email: invite_params[:email])
    end

    if @invite.save
      InviteMailer.invitation_email(@invite).deliver_later
      flash[:notice] = "👍 Invite sent"
    else
      flash[:alert] = "There was a problem sending the invite."
    end
    redirect_to account_path(@current_account)
  end

  def accept
    @invite = Invite.find_by(token: params[:id])
    if @invite.nil?
      flash[:alert] = "Invalid invitation token"
      redirect_to root_path
    else
      @user = User.new(email: @invite.email)
    end
  end

  def create_user_from_invite
    @invite = Invite.find_by(token: params[:id])
    if @invite.nil?
      flash[:alert] = "Invalid invitation token"
      redirect_to root_path
    elsif @invite.accepted?
      flash[:alert] = "Invitation already accepted"
      redirect_to root_path
    else
      @user = User.new(user_params)
      @user.skip_account_creation = true # Skip the creation of Account and Organization
      AccountMembership.create(user: @user, account: @invite.account)
      if @user.save
        @invite.update(accepted: true, invitee: @user)
        sign_in @user
        flash[:notice] = "Invitation accepted. Welcome!"
        redirect_to root_path
      else
        flash[:alert] = "There was a problem creating your account."
        render :accept
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  private

  def invite_params
    params.require(:invite).permit(:email)
  end
end
