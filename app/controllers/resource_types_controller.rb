class ResourceTypesController < ApplicationController
  # GET /resourcetypes
  def index
    @resource_types = ResourceType.all
    render json: @resource_types
  end
end
