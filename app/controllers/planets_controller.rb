class PlanetsController < ApplicationController
  before_action :set_planet, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # GET /planets
  def index
    gameworld = Gameworld.find_by(status: 'active')
    @planets = Planet.where(gameworld_id: gameworld.id, deleted_at: nil)
  end

  # GET /planets/1
  def show
    @planet
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_planet
    @planet = Planet.find(params[:id])
  end
end
