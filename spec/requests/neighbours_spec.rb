# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'neighbours', type: :request, capture_examples: true do
  path '/planets/{planet_id}/neighbours' do
    get('Retrieves all neighbours') do
      produces 'application/json'
      tags :neighbours
      parameter name: :planet_id, in: :path, schema: { type: :string, format: :uuid }

      response(200, 'Return all available neighbours') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/planet' }

        let(:gameworld) { create(:gameworld) }
        let(:planet) { create(:planet, gameworld: gameworld, x: 0, y: 0) }
        let(:neighbour) { create(:planet, gameworld: gameworld, x: 1, y: 0) }
        let(:planet_id) { planet.id }
        let(:neighbour_id) { neighbour.id }
        run_test!
      end
    end
  end

  path '/planets/{planet_id}/neighbours/{neighbour_id}' do
    get 'Retrieves a planets neighbour' do
      tags :neighbours
      produces 'application/json'
      parameter name: :planet_id, in: :path, schema: { type: :string, format: :uuid }
      parameter name: :neighbour_id, in: :path, schema: { type: :string, format: :uuid }

      response '200', 'Neighbour found' do
        schema '$ref' => '#/components/schemas/planet'

        let(:gameworld) { create(:gameworld) }
        let(:planet) { create(:planet, gameworld: gameworld, x: 0, y: 0) }
        let(:neighbour) { create(:planet, gameworld: gameworld, x: 1, y: 0) }
        let(:planet_id) { planet.id }
        let(:neighbour_id) { neighbour.id }
        run_test!
      end

      response '404', 'Not Found' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:planet_id) { 'invalid' }
        let(:neighbour_id) { 'invalid' }
        run_test!
      end
    end
  end
end
