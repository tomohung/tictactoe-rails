
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

  def pick!(valid_numbers, picked_number)
    return unless valid_numbers.include? picked_number
    valid_numbers.delete(picked_number)
    @picked_numbers << picked_number
  end

end

class Robot_Player < Player

  def pick!(valid_numbers, choose_number)
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

  attr_accessor :unpicked_numbers, :user1, :user2, :current_user, :steps

private
  def initialize(player1, player2)
    @unpicked_numbers = TicTacToeRuler::PICK_NUMBERS.clone
    @user1 = player1
    @user2 = player2
    @current_user = player1
    @steps = 0
  end
  
public

  def player_to_pick(picked_number)
    @current_user.pick!(unpicked_numbers, picked_number)
    @steps += 1 if current_user_is_user1?
    @current_user = current_user_is_user1? ? @user2 : @user1    
  end

  def current_user_is_user1?
    @current_user == @user1
  end
  
  def game_is_over?
    return user1 if user1.get_straight_number?
    return user2 if user2.get_straight_number?
    return 0 if unpicked_numbers.empty?
    return false
  end

  def again
    @unpicked_numbers = TicTacToeRuler::PICK_NUMBERS.clone
    user1.picked_numbers.clear
    user2.picked_numbers.clear
  end  

  def reset
    again
    @steps = 0
  end
end
