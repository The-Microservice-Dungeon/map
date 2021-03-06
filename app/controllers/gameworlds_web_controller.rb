# frozen_string_literal: true

class GameworldsWebController < WebController
  if ENV['RAILS_ENV'] == 'production'
    http_basic_authenticate_with name: 'gamemaster',
                                 password: Rails.application.credentials.basic_auth_pass
  end
  skip_before_action :verify_authenticity_token
  before_action :validate_params, only: %i[create]

  def index
    @gameworlds = Gameworld.order(created_at: :desc)
  end

  def show
    @gameworld = Gameworld.preload(planets: :resource).find(params[:id])
    planets = @gameworld.planets
    @gameworld2d = GameworldPrinter.planets_to_2d_array(planets)
  end

  def show_planet
    @planet = Planet.find(params[:planet_id])
    @resource = @planet.resource
    render layout: false if params[:inline] == 'true'
  end

  def set_deleted_at
    @planet = Planet.find(params[:planet_id])
    @planet.deleted_at = @planet.deleted_at ? nil : Time.now
    @planet.save!
    redirect_to action: 'show', id: @planet.gameworld_id
  end

  def create
    Replenishment.delete_all
    Mining.delete_all
    Resource.delete_all
    SpacestationCreation.delete_all
    Planet.delete_all
    Gameworld.delete_all

    @gameworld = Gameworld.new(name: params[:name])
    GameworldBuilder.create_regular_gameworld(@gameworld, params['player_amount'].to_i)

    if @gameworld.save
      @gameworld.publish_gameworld_created_event
      redirect_to action: 'index'
    end
  end

  def validate_params
    return if params['player_amount'].to_i.positive? && params['player_amount'].to_i < 100

    redirect_to action: 'index'
  end

  def replenish_resource
    @planet = Planet.find(params[:planet_id])
    replenishment = Replenishment.new(planet_id: @planet.id, resource_id: @planet.resource.id)
    replenishment.execute_replenishment
    redirect_to action: 'show', id: @planet.gameworld_id
  end
end
