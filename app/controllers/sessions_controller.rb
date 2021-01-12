class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user.try(:authenticate, params[:session][:password])
      if user.activated
        log_in user
        if params[:session][:remember_me] == Settings.session.remember_me
          remember(user)
        else
          forget(user)
        end
        redirect_back_or user
      else
        flash[:warning] = t "controller.session.warning"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "login.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
