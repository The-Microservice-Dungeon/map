class StatusController < ApplicationController
  def index
    @status = MapStatus.map_status
  end
end
