class GameworldsWebController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @gameworlds = Gameworld.all
  end

  def show
    @gameworld = Gameworld.find(params[:id])
    @gameworld2d = GameworldPrinter.gameworld_to_2d_array(@gameworld)
  end

  def create
    gameworld_builder = GameworldBuilder.create_regular_gameworld(10)
    @gameworld = gameworld_builder.gameworld

    if @gameworld.save
      gameworld_builder.finalize_async
      redirect_to action: 'show', id: @gameworld.id
    end
  end
end
