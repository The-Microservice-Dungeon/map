class StatusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    request.format = :json
    @status = MapStatus.map_status
  end
end
