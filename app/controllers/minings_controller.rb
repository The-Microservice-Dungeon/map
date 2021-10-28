class MiningsController < ApplicationController
  before_action :set_planet, only: %i[index]
  before_action :set_resource, only: %i[create]

  # GET /planets/1/minings
  def index
    @minings = Mining.where(planet_id: params[:id]).all

    render json: @minings
  end

  # POST /planets/1/minings
  def create
    mining = @resource.execute_mining(mining_params[:amount_mined])
    render json: mining, status: :created
  end

  private

  def set_planet
    @planet = Planet.find(params[:id])
  end

  def set_resource
    resource_type = ResourceType.find_by_name(mining_params[:resource_type])
    @resource = Resource.of_type(resource_type.id).where(planet_id: params[:id]).take!
  end

  def mining_params
    params.require(:mining).permit(%i[resource_type amount_mined])
  end
end
