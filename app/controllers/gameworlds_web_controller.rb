class GameworldsWebController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @gameworlds = Gameworld.all
  end

  def show
    @gameworld = Gameworld.find(params[:id])
    planets = @gameworld.planets.preload(:resource)
    @gameworld2d = GameworldPrinter.planets_to_2d_array(planets)
  end

  def create
    @gameworld = Gameworld.new

    if @gameworld.save
      CreateGameworldJob.perform_later(@gameworld.id, params[:player_amount].to_i)
      redirect_to action: 'show', id: @gameworld.id
    end
  end
end
