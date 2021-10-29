class NeighboursController < ApplicationController
  before_action :set_planet, only: %i[index show]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # GET /planets/1/neighbours
  def index
    render json: @planet.neighbours.to_json(except: %i[x y])
  end

  # GET /planets/1/neighbours/1
  def show
    render json: @planet.neighbours.find(params[:neighbour_id]).to_json(except: %i[x y])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_planet
    @planet = Planet.find(params[:id])
  end
end
