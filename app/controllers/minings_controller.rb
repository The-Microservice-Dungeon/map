class MiningsController < ApplicationController
  before_action :set_planet_and_resource, only: %i[create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_params_missing
  rescue_from ActiveRecord::StatementInvalid, with: :render_unprocessable_entity

  # GET /planets/1/minings
  def index
    @minings = Mining.where(planet_id: params[:id]).all
  end

  # POST /planets/1/minings
  def create
    @mining = Mining.new resource_id: @resource.id,
                         planet_id: @planet.id,
                         amount_requested: mining_params[:amount_requested],
                         transaction_id: nil

    @mining.execute

    if @mining.save
      render json: @mining, status: :created
    else
      render json: @mining.errors, status: :unprocessable_entity
    end
  end

  private

  def set_planet_and_resource
    @planet = Planet.find(params[:id])
    @resource = Resource.where(planet_id: @planet.id).take!
  end

  def mining_params
    params.require(:mining).permit(%i[amount_requested])
  end
end
