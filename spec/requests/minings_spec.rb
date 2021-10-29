require 'swagger_helper'

RSpec.describe 'minings', type: :request, capture_examples: true do
  path '/planets/{id}/minings' do
    get('Retrieves all minings') do
      produces 'application/json'
      tags :minings
      parameter name: :id, in: :path, type: :string

      response(200, 'Return all available minings') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/mining' }

        let(:id) { create(:planet).id }
        run_test!
      end
    end

    post 'Creates a mining' do
      tags :minings
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :mining, in: :body, schema: {
        type: :object,
        properties: {
          mining: { type: :object,
                    properties: {
                      player_id: { type: :string, format: :uuid },
                      resource_type: { type: :string, enum: %w[coal iron gem gold platin] },
                      amount_mined: { type: :integer, minimum: 1 }
                    }, required: %w[player_id resource_type amount_mined] }
        },
        required: %w[mining]
      }

      response '201', 'Created' do
        schema '$ref' => '#/components/schemas/mining'

        let(:planet) { create(:planet_with_resources) }
        let(:id) { planet.id }
        let(:mining) { { mining: { resource_type: 'coal', amount_mined: 100, planet_id: planet.id } } }
        run_test!
      end

      response '404', 'Not Found' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:planet) { create(:planet) }
        let(:id) { planet.id }
        let(:mining) { { mining: { resource_type: 'coal', amount_mined: 100, planet_id: planet.id } } }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:planet) { create(:planet_with_resources) }
        let(:id) { planet.id }
        let(:mining) { { mining: { resource_type: 'obsidian', amount_mined: 100, planet_id: planet.id } } }
        run_test!
      end
    end
  end
end
