
module TicTacToeRuler
  THREE_LINE_SET = [[1, 2, 3], [4, 5, 6], [7, 8, 9], 
                    [1, 4, 7], [2, 5, 8], [3, 6, 9], 
                    [1, 5, 9], [3, 5, 7]]

  PICK_NUMBERS = (1..9).to_a
end


class Player

  attr_accessor :name, :picked_numbers

  def initialize(name)
    @name = name
    @picked_numbers = []
  end

  def get_straight_number?
    TicTacToeRuler::THREE_LINE_SET.each do |set|
      result = 0
      set.each do |number|
        if picked_numbers.include?(number)
          result += 1
        end
      end
      return true if result == set.size
    end
    false
  end

  def pick!(valid_numbers)
    value = 0
    loop do
      value = gets.chomp.to_i
      break if valid_numbers.include?(value)
      puts "Input number is invalid, try again..."
    end
    valid_numbers.delete(value)
    @picked_numbers << value
  end

end

class Robot_Player < Player

  def pick!(valid_numbers)
    choose_number = nil

    # 1. pick number to let computer get a straight line
    choose_number ||= pick_number_to_win(valid_numbers)
    # 2. pick number to prevent user get a straight line
    choose_number ||= pick_number_to_prevent_lose(valid_numbers)
    # 3. pick number to prevent opposite player get a double way
    choose_number ||= pick_number_to_prevent_double_way(valid_numbers)
    # 4. pick number to pick a possible win
    choose_number ||= pick_number_to_possible_win(valid_numbers)
    
    return unless choose_number    
    valid_numbers.delete(choose_number)
    @picked_numbers << choose_number
  end 
   
  def test_straight_line?(test_picked_numbers, test_number)
    TicTacToeRuler::THREE_LINE_SET.each do |set| 
      next if !set.include?(test_number)
      line = set.select {|number| number == test_number || test_picked_numbers.include?(number)}      
      return true if line.size == set.size
    end
    false
  end

  def pick_number_to_win(valid_numbers)
    valid_numbers.each do |number|
      return number if test_straight_line?(picked_numbers, number)
    end
    nil
  end

  def get_opposite_player_picked_number(valid_numbers)
    TicTacToeRuler::PICK_NUMBERS.select do |number| 
      !picked_numbers.include?(number) && !valid_numbers.include?(number)
    end
  end

  def pick_number_to_prevent_lose(valid_numbers)
    opposite_player_picked_numbers = get_opposite_player_picked_number(valid_numbers)
    valid_numbers.each do |number|
      return number if test_straight_line?(opposite_player_picked_numbers, number)
    end
    nil
  end

  def retrieve_possible_win_number(result_hash)
    last_result = 0
    choose_number = 0
    result_hash.each do |key, value|
      if value > last_result
        last_result = value
        choose_number = key
      end
    end
    choose_number
  end  

  def pick_number_to_possible_win(valid_numbers)
    result_hash = {}

    valid_numbers.each do |number|
      result = 0     
      TicTacToeRuler::THREE_LINE_SET.each do |set|      
        next unless set.include?(number)        
        set.each do |element|
          if !valid_numbers.include?(element) && !picked_numbers.include?(element)
            result -= 1
          else
            result += 1
          end
        end
      end
      result_hash[number] = result
    end 
    retrieve_possible_win_number(result_hash)
  end

  def pick_number_to_prevent_double_way(valid_numbers)
    opposite_player_picked_numbers = get_opposite_player_picked_number(valid_numbers)

    valid_numbers.each do |number|  
      record = 0
      TicTacToeRuler::THREE_LINE_SET.each do |set|            
        next if !set.include?(number)
        
        if !set.select {|element| opposite_player_picked_numbers.include?(element)}.empty? &&
          set.select {|element| picked_numbers.include?(element)}.empty?
            record += 1 
        end
      end 
      return number if record >= 2
    end
    nil
  end

end

class TicTacToeBoard

  attr_accessor :unpicked_numbers, :user1, :user2, :current_user

private
  def initialize(player1, player2)
    @unpicked_numbers = TicTacToeRuler::PICK_NUMBERS.clone
    @user1 = player1
    @user2 = player2
    @current_user = player1
  end
  
  def output_who_picked(value)
    word = ""
    case 
    when user1.picked_numbers.include?(value)
      word = 'x'
    when user2.picked_numbers.include?(value)
      word = 'o'
    else
      word = ' '
    end
    word
  end  

public

  def ask_player_to_pick
    @current_user.pick!(unpicked_numbers)
    @current_user = current_user == user1 ? user2 : user1
  end

  def show_figure
    if unpicked_numbers.size == TicTacToeRuler::PICK_NUMBERS.size
      puts "
       1 | 2 | 3
      ---+---+---
       4 | 5 | 6
      ---+---+---
       7 | 8 | 9
      "
      return
    end
    puts "
       #{output_who_picked(1)} | #{output_who_picked(2)} | #{output_who_picked(3)}  
      ---+---+---
       #{output_who_picked(4)} | #{output_who_picked(5)} | #{output_who_picked(6)}  
      ---+---+---
       #{output_who_picked(7)} | #{output_who_picked(8)} | #{output_who_picked(9)}  
     "
  end

  def game_is_over?
    return "#{user1.name}, you win!!" if user1.get_straight_number?
    return "#{user2.name}, is the true hero!!" if user2.get_straight_number?
    return "Tie Game" if unpicked_numbers.empty?
    return false
  end

  def clear
    @unpicked_numbers = TicTacToeRuler::PICK_NUMBERS.clone
    user1.picked_numbers.clear
    user2.picked_numbers.clear
  end  
end

class TicTacToeGame

  attr_accessor :game_board

  def initialize
    say "Game mode: 1) Single Play. 2)Two Players."
    mode = gets.chomp

    say "Hero, enter your name:"
    player1_name = gets.chomp
    player1_name = "Guest" if player1_name.empty?

    player1 = Player.new(player1_name)
    if mode == "2"
      say "Another Hero, enter your name: "
      player2_name = gets.chomp
      player2_name = "Anonymous" if player2_name.empty?
      player2 = Player.new(player2_name)
    else
      say "#{player1_name}, come to beat Super Tomo!!"
      player2 = Robot_Player.new("Super Tomo")
    end

    @game_board = TicTacToeBoard.new(player1, player2)
  end

  def say(message)
    puts "=> #{message}"
  end 

  def play

    loop do
      result = ""
      game_board.clear

      loop do
        system("clear")
        say "Welcome to Tomo's Tic-Tac-Toe Game" 
        game_board.show_figure
        
        puts "--> #{game_board.current_user.name}'s turn <--"
        say "Choose one number (1 ~ 9):"

        game_board.ask_player_to_pick
  
        result = game_board.game_is_over?
        break if result
      end

      system("clear")
      say "Result: "
      game_board.show_figure
      say result

      puts "\n"
      say "Play again? (y/n)"
      break if gets.chomp.downcase == 'n'
    end
  end
end
