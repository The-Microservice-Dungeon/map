class GameworldsController < ApplicationController
  before_action :set_gameworld, only: %i[show update destroy]

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
    if gameworld_params[:player_amount] > 0 && gameworld_params[:round_amount] > 0
      @gameworld = Gameworld.new

      if @gameworld.save
        render json: @gameworld, status: :created, location: @gameworld
      else
        render json: @gameworld.errors, status: :unprocessable_entity
      end
    else
      render json: {
        'status' => 422,
        'error' => 'Unprocessable Entity',
        'exception' => 'player_amount and round_amount need to be larger than 0'
      },
             status: :unprocessable_entity
    end

    # TODO: Generate Planets based on player_amount && round_amount
    # Incoming params: player_amount, round_amount
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
end
