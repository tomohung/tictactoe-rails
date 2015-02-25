class GameRecordsController < ApplicationController
  def create
    if logged_in?
      record = current_user.game_records.new
      record.attack_times = params[:steps]
      record.status = params[:status]
      if !record.save
        record.errors.full_messages do |msg|
          flash[msg.to_sym] = msg
        end
      end
    else
      flash[:error] = 'Please Login first.'
    end
    redirect_to game_records_path
  end
  
  def index
    @game_records = GameRecord.all.order('attack_times DESC')
  end
  
end