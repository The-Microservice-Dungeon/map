class PlanetsController < ApplicationController
  before_action :set_planet, only: %i[show update destroy]

  # GET /planets
  def index
    @planets = Planet.all

    render json: @planets
  end

  # GET /planets/1
  def show
    render json: @planet
  end

  # POST /planets
  def create
    @planet = Planet.new(planet_params)

    if @planet.save
      render json: @planet, status: :created, location: @planet
    else
      render json: @planet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /planets/1
  def update
    if @planet.update(planet_params)
      render json: @planet
    else
      render json: @planet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /planets/1
  def destroy
    @planet.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_planet
    @planet = Planet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def planet_params
    params.require(:planet).permit(:movement_difficulty, :recharge_multiplicator, :planet_type, :taken_at,
                                   :gameworld_id, :x, :y)
  end
end
