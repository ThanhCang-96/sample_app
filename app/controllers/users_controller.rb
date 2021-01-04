class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    return if @user = User.find_by(id: params[:id])

    flash[:error] = t "users.error"
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t "users.create_user_successful"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
