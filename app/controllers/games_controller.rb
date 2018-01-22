class GamesController < ApplicationController
  
  def new
    @game = Game.new
  end
  
  def create
    game = Game.new(game_params)
    
    if game.save
      # TODO Send success message to UI
      update_rankings(game)
      redirect_to history_path
    else
      # TODO Send error message to the UI
      render :new
    end
  end
  
  def history
    @games1 = Game.joins(:player2).where(player1_id: current_user.id)
    @games2 = Game.joins(:player1).where(player2_id: current_user.id)
  end
  
  def leaderboard
    @rankings = Ranking.joins(:user)
  end
  
  private
  def game_params
    params.require(:game).permit(:player1_id, :player2_id, :game_date, :score1, 
                   :score2)
  end
  
  def update_rankings(game)
    if not Ranking.exists?
      create_leaderboard
    end
    
    if not Ranking.exists?(:user_id => game.player1_id)
      create_new_ranking(game.player1_id)
    end
    
    if not Ranking.exists?(:user_id => game.player2_id)
      create_new_ranking(game.player2_id)
    end
    
    rankingP1 = Ranking.where(:user_id => game.player1_id).first
    rankingP2 = Ranking.where(:user_id => game.player2_id).first
    
    if game.score1 > game.score2
      ratingP2 = rankingP2.rating + game.score2
      ratingP1 = calculate_winner_rating(game.score1, game.score2, rankingP1, rankingP2)
    else
      ratingP1 = rankingP1.rating + game.score1
      ratingP2 = calculate_winner_rating(game.score2, game.score1, rankingP2, rankingP1)
    end
    
    rankingP1.update(:rating => ratingP1)
    rankingP2.update(:rating => ratingP2)
    
    # TODO: update ranking
    
  end
  
  def calculate_winner_rating(winner_score, loser_score, winner, loser)
    score_difference = winner_score - loser_score
    winner_rating = winner.rating + winner_score
    # There is more merit if an underdog wins, but only if he already has a
    # ranking
    if winner.ranking != 2147483647 and winner.ranking > loser.ranking
      multiplier = winner.ranking - loser.ranking
      winner_rating += multiplier*score_difference
    else
      winner_rating += score_difference
    end
    
    return winner_rating
  end
  
  def create_leaderboard
    users = User.all
    users.each do |user|
      create_new_ranking(user.id)
    end
  end
  
  def create_new_ranking(id)
    ranking = Ranking.new(:user_id => id, :ranking => 2147483647, 
      :rating => 0, :games_played => 0, :games_won => 0)
    # TODO validations
    ranking.save
  end

end