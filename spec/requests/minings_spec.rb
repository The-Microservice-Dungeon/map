require 'swagger_helper'

RSpec.describe 'minings', type: :request, capture_examples: true do
  path '/planets/{id}/minings' do
    get('Retrieves all minings') do
      produces 'application/json'
      tags :minings
      parameter name: :id, in: :path, type: :string, format: :uuid

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
      parameter name: :id, in: :path, type: :string, format: :uuid
      parameter name: :mining, in: :body, schema: {
        type: :object,
        properties: {
          mining: { type: :object,
                    properties: {
                      amount_requested: { type: :integer, minimum: 1 }
                    }, required: %w[amount_requested] }
        },
        required: %w[mining]
      }

      response '201', 'Created' do
        schema '$ref' => '#/components/schemas/mining'

        let(:planet) { create(:planet_with_resources) }
        let(:id) { planet.id }
        let(:mining) { { mining: { amount_requested: 100 } } }
        run_test!
      end

      response '404', 'Not Found' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:planet) { create(:planet) }
        let(:id) { planet.id }
        let(:mining) { { mining: { amount_requested: 100 } } }
        run_test!
      end
    end
  end
end
