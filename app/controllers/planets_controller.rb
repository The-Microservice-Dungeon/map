class PlanetsController < ApplicationController
  before_action :set_planet, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # GET /planets
  def index
    @planets = Planet.all

    render json: @planets.to_json(include: { neighbours: { except: %i[x y] } }, except: %i[x y])
  end

  # GET /planets/1
  def show
    render json: @planet.to_json(include: { neighbours: { except: %i[x y] } }, except: %i[x y])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_planet
    @planet = Planet.find(params[:id])
  end
end
