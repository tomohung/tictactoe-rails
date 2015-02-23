module ApplicationHelper

  def get_symbol(number)
    if @player_picked_numbers.include? number
      'O'
    elsif @host_picked_numbers.include? number
      'X'
    else
      link_to number.to_s, game_create_path(id: number.to_s), method: :post
    end
  end

end
