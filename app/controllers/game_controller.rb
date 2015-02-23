
require 'oo_tic_tac_toe.rb'

class GameController < ApplicationController
  
  before_action :create_game
  before_action :get_board_data, only: [:show, :create]

  def index

  end

  def show
    
  end

  def create
    @board
    redirect_to game_show_path
  end


private
  def create_game
    return if session[:board]

    player = Player.new('Guest')
    robot = Robot_Player.new("Robot")
    session[:board] = TicTacToeBoard.new(player, robot)

  end

  def get_board_data
    
    @board = session[:board]
    player = session[:board]["user1"]
    host = session[:board]["user2"]
    
    @player_picked_numbers = player["picked_numbers"]
    @host_picked_numbers = host["picked_numbers"]
  end

end