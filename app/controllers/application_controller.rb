# frozen_string_literal: true

class ApplicationController < ActionController::API
  after_action :save_last_request_time

  def render_not_found(exception)
    render json: {
      'status' => 404,
      'error' => 'Not Found',
      'exception' => exception
    },
           status: :not_found
  end

  def render_params_missing(exception)
    render json: {
      'status' => 400,
      'error' => 'Bad Request',
      'exception' => exception
    },
           status: :bad_request
  end

  def render_unprocessable_entity(exception)
    render json: {
      'status' => 422,
      'error' => 'Unprocessable Entity',
      'exception' => exception
    },
           status: :unprocessable_entity
  end

  private

  def save_last_request_time
    MapStatus.map_status.update(last_request_time: Time.now) unless request.path == '/status'
  end
end
