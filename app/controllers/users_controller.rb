class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]

  def show

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(set_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to game_path
    else
      @user.errors.full_messages.each do |msg|
        flash[msg.to_sym] = msg
      end
      
      render :new
    end
  end

  def edit

  end

  def update

  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def set_params
    params.require(:user).permit(:username, :password)
  end

end