require 'oo_tic_tac_toe'

class GameController < ApplicationController
  
  @@game_board = nil
  before_action :create_game
  before_action :get_board_data, only: [:show, :create, :over, :new]
  before_action :host_pick, only: [:show]

  def index
  end

  def show
    redirect_to game_over_path if @@game_board.game_is_over?
  end

  def new
    result = @@game_board.game_is_over?
    if result == @player || result == @host
      @@game_board.reset
    else
      @@game_board.again
    end
    redirect_to game_show_path
  end
  
  def over
    result = @@game_board.game_is_over?
    if !result
      @message = 'Game is Over.'
    elsif result == 0
      @message = 'Game is a Tie.'
    else
      @message = result.name + ' Win!!'
    end
        
  end
  
  def create

    picked_number = params[:id].to_i
    @@game_board.player_to_pick(picked_number)

    if @@game_board.game_is_over?
      redirect_to game_over_path
    else
      redirect_to game_show_path
    end
  end

private
  def host_pick
    @board.player_to_pick(0) if !@board.current_user_is_user1?
  end
  
  def create_game
    return if @@game_board

    player = Player.new('Guest')
    robot = Robot_Player.new("Robot")
    @@game_board = TicTacToeBoard.new(player, robot)
  end

  def get_board_data
    @board = @@game_board
    
    @player = @board.user1
    @host = @board.user2

    @player_picked_numbers = @player.picked_numbers
    @host_picked_numbers = @host.picked_numbers
  end

end