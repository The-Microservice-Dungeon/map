class NeighboursController < ApplicationController
  before_action :set_planet, only: %i[index show]
  rescue_from ActiveRecord::RecordNotFound, with: :neighbour_not_found

  # GET /planets/1/neighbours
  def index
    render json: @planet.neighbours
  end

  # GET /planets/1/neighbours/1
  def show
    render json: @planet.neighbours.find(params[:neighbour_id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_planet
    @planet = Planet.find(params[:id])
  end

  def neighbour_not_found
    render json: {
      'status' => 404,
      'error' => 'Not Found',
      'exception' => "planet with id #{params[:id]} is not a neighbour of planet with id #{params[:neighbour_id]}"
    },
           status: :not_found
  end
end
