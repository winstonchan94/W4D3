class SessionsController < ApplicationController
  before_action :require_logout, only: [:new]

  def require_logout
    if logged_in?
      flash[:errors] = ['You are already logged in']
      redirect_to root_url
    end
  end

  def new
    @hide_header_login = true
    render :new
  end

  def create
    user = User.find_by_credentials(params[:login][:user_name], params[:login][:password])
    if user
      login_user!(user)
      redirect_to root_url
    else
      flash.now[:errors] = ["Incorrect username or password"]
      @user_name = params[:login][:user_name]
      @hide_header_login = true
      render :new
    end
  end

  def destroy
    user = current_user
    if user
      user.reset_session_token!
      session[:session_token] = nil
      flash[:success] = "Successfully logged out"
    else
      flash[:errors] = ["There were some complications logging you out"]
    end
    redirect_to root_url
  end
end
