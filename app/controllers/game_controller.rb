require 'oo_tic_tac_toe'

class GameController < ApplicationController
  
  @@game_board = nil
  before_action :create_game
  before_action :get_board_data, only: [:show, :create, :over, :new]
  before_action :host_pick, only: [:show]

  def index
  end

  def show
    redirect_to game_over_path if @board.game_is_over?
  end

  def new
    result = @board.game_is_over?
    if result == @player || result == @host
      @board.reset
    else
      @board.again
    end
    redirect_to game_path
  end
  
  def over
    result = @board.game_is_over?
    if !result
      @message = 'Game is Over.'
    elsif result == 0
      @message = 'TIE'
    elsif result == @player
      @message = 'WIN'
    else
      @message = 'LOSE'
    end
  end
  
  def create

    @picked_number = params[:id].to_i
    @board.player_to_pick(@picked_number)

    winner = @board.game_is_over?
    if winner
      flash[:notice] = 'INCREDIBLE!! You Defeat Titan!' if winner == @player
      render :js => "window.location = '/game/over'"
      return
    else
      respond_to do |format|
        format.html do
          redirect_to game_path
        end
        format.js do          
          host_pick
          winner = @board.game_is_over?
          if winner
            flash[:notice] = 'OH NO!! You are DEAD!' if winner == @host
            render :js => "window.location = '/game/over'"
          end
        end
      end
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