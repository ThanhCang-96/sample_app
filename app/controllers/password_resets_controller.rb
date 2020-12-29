class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
      if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = t("controller.pass_reset.create.info")
        redirect_to root_url
      else
        flash.now[:danger] = t("controller.pass_reset.create.danger")
        render :new
      end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("controller.pass_reset.update.erros_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t("controller.pass_reset.update.success")
      redirect_to @user
    else
      render :edit
    end
  end

  def new; end

  def edit; end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    return if @user = User.find_by(email: params[:email])

    flash[:error] = t "users.error"
    redirect_to root_path
  end

  def valid_user
    return if (@user && @user.activated && @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "controller.pass_reset.check_expiration.danger"
      redirect_to new_password_reset_url
    end
  end
end
