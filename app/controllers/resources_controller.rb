# frozen_string_literal: true

class ResourcesController < ApplicationController
  before_action :set_planet, only: %i[index]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # GET /planets/1/resources
  def index
    @resources = [@planet.resource]
  end

  private

  def set_planet
    @planet = Planet.find(params[:id])
  end
end
