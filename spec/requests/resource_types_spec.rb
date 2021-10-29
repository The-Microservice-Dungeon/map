require 'swagger_helper'

RSpec.describe 'resource_types', type: :request, capture_examples: true do
  path '/resource_types' do
    get('Retrieves all resource_types') do
      produces 'application/json'
      tags :resource_types

      response(200, 'Return all available resource_types') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/resource_type' }

        let!(:resource_type) { create(:resource_type) }
        run_test!
      end
    end
  end
end
