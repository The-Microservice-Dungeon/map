class PlanetsController < ApplicationController
  before_action :set_planet, only: %i[show take]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # GET /planets
  def index
    @planets = Planet
               .filter(params.slice(:planet_type))
               .joins(:gameworld)
               .preload(:resource)
               .where(gameworld: { status: 'active' }, deleted_at: nil)
               .paginate(page: params[:page], per_page: 50)
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
