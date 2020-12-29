class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.user.account.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailers.user.password.subject")
  end
end
