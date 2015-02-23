
require 'oo_tic_tac_toe.rb'

class GameController < ApplicationController
  
  before_action :create_game

  def index

  end

  def show
    
  end

  def create
    
    redirect_to game_show_path
  end


private
  def create_game
    return if session[:board]

    player = Player.new('Guest')
    robot = Robot_Player.new("Robot")
    session[:board] = TicTacToeBoard.new(player, robot)

  end

end