class CreateGameRecords < ActiveRecord::Migration
  def change
    create_table :game_records do |t|
      t.integer :user_id
      t.integer :attack_times
      t.string :status
      t.timestamps
    end
  end
end
