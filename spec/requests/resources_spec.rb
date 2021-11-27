require 'swagger_helper'

RSpec.describe 'resources', type: :request, capture_examples: true do
  path '/planets/{planet_id}/resources' do
    get('Retrieves all resources') do
      produces 'application/json'
      tags :resources
      parameter name: :planet_id, in: :path, schema: { type: :string, format: :uuid }

      response(200, 'Return all available resources') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/resource' }

        let(:planet) { create(:planet_with_resources) }
        let(:planet_id) { planet.id }
        run_test!
      end
    end
  end
end
