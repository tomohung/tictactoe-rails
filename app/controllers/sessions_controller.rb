class SessionsController < ApplicationController
  def new
    @user = User.new
  end
  
  def create

    @user = User.find_by username: params[:username]    

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to game_path
    else
      flash[:error] = 'Username or Password is incorrect, please try again.'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end