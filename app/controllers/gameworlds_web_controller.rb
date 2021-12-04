class GameworldsWebController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @gameworlds = Gameworld.all
  end

  def show
    @gameworld = Gameworld.preload(planets: :resource).find(params[:id])
    planets = @gameworld.planets
    @gameworld2d = GameworldPrinter.planets_to_2d_array(planets)
  end

  def create
    @gameworld = Gameworld.new(name: params[:name])
    GameworldBuilder.create_regular_gameworld(@gameworld, params['player_amount'].to_i)

    if @gameworld.activate
      CreateGameworldResourcesJob.perform_later(@gameworld.id)
      redirect_to action: 'show', id: @gameworld.id
    end
  end
end
