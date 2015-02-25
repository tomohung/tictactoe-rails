class GameRecord < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :attack_times, presence: true
  validates :status, presence: true
end