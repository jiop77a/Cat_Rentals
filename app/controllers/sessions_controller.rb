class SessionsController < ApplicationController
  before_filter :ensure_single_login, only: [:new, :create]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(session_params[:user_name], session_params[:password])

    if @user
      login(@user)
      redirect_to cats_url
    else
      flash[:errors] << "Invalid user credentials."
      redirect_to new_sessions_url
    end
  end

  def destroy
    logout
    redirect_to cats_url
  end

  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end

  def ensure_single_login
    if @current_user
      redirect_to cats_url
    end
  end
end
