class GamesController < ApplicationController
  
  def new
    @game = Game.new
  end
  
  def create
    game = Game.new(game_params)
    
    if game.save
      # TODO Send success message to UI
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
  
  private
  def game_params
    params.require(:game).permit(:player1_id, :player2_id, :game_date, :score1, 
                   :score2)
  end
    
end