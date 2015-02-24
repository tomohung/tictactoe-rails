module ApplicationHelper

  def get_symbol(number)
    if @player_picked_numbers.include? number
      'O'
    elsif @host_picked_numbers.include? number
      'X'
    else
      link_to game_create_path(id: number.to_s), method: :post do
        number.to_s
      end
    end
  end

end
