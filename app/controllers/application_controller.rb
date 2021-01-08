class ApplicationController < ActionController::Base
  before_action :set_locale

  include SessionsHelper

  def hello
    render html: "hello, world!"
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controller.user_controller.logged_in_user.danger"
      redirect_to login_url
    end
  end
end
