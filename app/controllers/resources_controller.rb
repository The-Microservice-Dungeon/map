class ResourcesController < ApplicationController
  before_action :set_planet, only: %i[index show]
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  # GET /planets/1/resources
  def index
    render json: @planet.resources
  end

  # GET /planets/1/resources/1
  def show
    render json: @planet.resources.find(params[:resource_id])
  end

  private

  def set_planet
    @planet = Planet.find(params[:id])
  end

  def resource_not_found
    render json: {
      'status' => 404,
      'error' => 'Not Found',
      'exception' => "resource #{params[:resource_id]} could not be found on planet #{params[:id]}"
    },
           status: :not_found
  end
end
