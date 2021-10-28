class MiningsController < ApplicationController
  before_action :set_resource, only: %i[create]

  # GET /planets/1/minings
  def index
    @minings = Mining.where(planet_id: params[:id])

    render json: @minings
  end

  # POST /planets/1/minings
  def create
    mining = @resource.execute_mining(params[:amount_mined])
    render json: mining, status: :created
  end

  private

  def set_resource
    @resource = Resource.of_type(params[:resource_type]).where(planet_id: params[:id]).take!
  end
end
