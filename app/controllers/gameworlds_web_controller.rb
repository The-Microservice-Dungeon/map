class GameworldsWebController < ApplicationController

  def index
    @gameworlds = Gameworld.all
  end

  def show
    @gameworld = Gameworld.find(params[:id])
    @gameworld2d = GameworldPrinter.gameworld_to_2d_array(@gameworld)
  end
end