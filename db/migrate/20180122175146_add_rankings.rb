class AddRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :user_id
      t.integer :ranking
      t.integer :rating
      t.integer :games_played
      t.integer :games_won
    end
  end
end
