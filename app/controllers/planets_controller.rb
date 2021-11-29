class PlanetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_planet, only: %i[show take]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # GET /planets
  def index
    @planets = Planet
               .filter(params.slice(:planet_type, :taken))
               .joins(:gameworld)
               .preload(:resource)
               .where(gameworld: { status: 'active' }, deleted_at: nil)
               .paginate(page: params[:page], per_page: 50)
  end

  # GET /planets/1
  def show
    @planet
  end

  # PATCH /planets/1
  def take
    @planet.taken_at = params[:taken_at]
    if @planet.save
      render :show, status: :ok, formats: :json
    else
      render json: @planet.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_planet
    @planet = Planet.find(params[:id])
  end
end
