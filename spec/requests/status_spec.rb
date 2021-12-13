# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'status', type: :request, capture_examples: true do
  path '/status' do
    get("Retrieves the service's status") do
      produces 'application/json'
      tags :status

      response(200, 'Ok') do
        schema type: :object,
               properties: {
                 online: { type: :boolean, example: true },
                 version: { type: :string, example: '1.0' },
                 last_request_time: { type: :string, format: 'date-time' }
               }
        run_test!
      end
    end
  end
end
