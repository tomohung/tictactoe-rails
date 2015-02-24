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
      
    else

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
    params.require(:users).permit(:username, :password)
  end

end