# frozen_string_literal: true

class NeighboursController < ApplicationController
  before_action :set_planet, only: %i[index show]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # GET /planets/1/neighbours
  def index
    @neighbours = @planet.neighbours
  end

  # GET /planets/1/neighbours/1
  def show
    @neighbour = @planet.neighbours.find { |neighbour| neighbour.id == params[:neighbour_id] }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_planet
    @planet = Planet.find(params[:id])
  end
end
