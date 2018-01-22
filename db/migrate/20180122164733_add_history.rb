class AddHistory < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.date :game_date
      t.integer :score1
      t.integer :score2
    end
  end
end
