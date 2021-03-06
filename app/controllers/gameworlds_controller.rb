# frozen_string_literal: true

class GameworldsController < ApplicationController
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
    Replenishment.delete_all
    Mining.delete_all
    Resource.delete_all
    SpacestationCreation.delete_all
    Planet.delete_all
    Gameworld.delete_all

    @gameworld = Gameworld.new
    GameworldBuilder.create_regular_gameworld(@gameworld, gameworld_params[:player_amount].to_i)

    if @gameworld.save
      @gameworld.publish_gameworld_created_event

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
    render_unprocessable_entity('player_amount needs to be positive') unless gameworld_params[:player_amount].positive?
    render_unprocessable_entity('player_amount needs to be < 100') unless gameworld_params[:player_amount] < 100
  end
end
