class GameworldsController < ApplicationController
  before_action :set_gameworld, only: %i[show update destroy]
  before_action :validate_params, only: %i[create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_params_missing

  # GET /gameworlds
  def index
    @gameworlds = Gameworld.all

    render json: @gameworlds
  end

  # GET /gameworlds/1
  def show
    render json: @gameworld
  end

  # POST /gameworlds
  def create
    @gameworld = Gameworld.new

    if @gameworld.save
      render json: @gameworld, status: :created, location: @gameworld
    else
      render json: @gameworld.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gameworld
    @gameworld = Gameworld.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def gameworld_params
    params.require(:gameworld).permit(%i[player_amount round_amount])
  end

  def validate_params
    return if gameworld_params[:player_amount].positive? && gameworld_params[:round_amount].positive?

    render_unprocessable_entity('player_amount and round_amount need to be positive')
  end
end
