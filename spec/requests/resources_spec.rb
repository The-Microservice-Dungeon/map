require 'swagger_helper'

RSpec.describe 'resources', type: :request, capture_examples: true do
  path '/planets/{id}/resources' do
    get('Retrieves all resources') do
      produces 'application/json'
      tags :resources
      parameter name: :id, in: :path, type: :string

      response(200, 'Return all available resources') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/resource' }

        let(:id) { create(:planet).id }
        run_test!
      end
    end
  end

  path '/planets/{id}/resources/{resource_id}' do
    get 'Retrieves a planets resources' do
      tags :resources
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :resource_id, in: :path, type: :string

      response '200', 'Resource found' do
        schema '$ref' => '#/components/schemas/resource'

        let(:planet) { create(:planet) }
        let(:id) { planet.id }
        let(:resource_id) { create(:resource, planet: planet).id }
        run_test!
      end

      response '404', 'Not Found' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:id) { 'invalid' }
        let(:resource_id) { 'invalid' }
        run_test!
      end
    end
  end
end
