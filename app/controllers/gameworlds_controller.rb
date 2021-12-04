class GameworldsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_gameworld, only: %i[show update destroy]
  before_action :validate_params, only: %i[create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_params_missing

  # GET /gameworlds
  def index
    @gameworlds = Gameworld.all
  end

  # GET /gameworlds/1
  def show
    @gameworld
  end

  # POST /gameworlds
  def create
    @gameworld = Gameworld.new
    GameworldBuilder.create_regular_gameworld(@gameworld, gameworld_params[:player_amount].to_i)

    if @gameworld.activate
      CreateGameworldResourcesJob.perform_later(@gameworld.id)
      render :show, status: :created, formats: :json
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
    params.require(:gameworld).permit(%i[player_amount])
  end

  def validate_params
    return if gameworld_params[:player_amount].positive?

    render_unprocessable_entity('player_amount needs to be positive')
  end
end
