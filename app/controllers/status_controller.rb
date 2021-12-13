# frozen_string_literal: true

class StatusController < ApplicationController
  def index
    @status = MapStatus.map_status
  end
end
