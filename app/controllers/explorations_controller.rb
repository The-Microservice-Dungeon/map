class ExplorationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_planet, only: %i[create]
  rescue_from ActionController::ParameterMissing, with: :render_params_missing
  rescue_from ActiveRecord::StatementInvalid, with: :render_unprocessable_entity

  # POST /planets/:planet_id/explorations
  def create
    @exploration = Exploration.new(planet_id: @planet.id, transaction_id: exploration_params[:transaction_id])

    if @exploration.save
      render json: @exploration, status: :created
    else
      render json: @exploration.errors, status: :unprocessable_entity
    end
  end

  private

  def set_planet
    @planet = Planet.find(params[:planet_id])
  end

  # Only allow a list of trusted parameters through.
  def exploration_params
    params.require(:exploration).permit(:planet_id, :transaction_id)
  end
end
