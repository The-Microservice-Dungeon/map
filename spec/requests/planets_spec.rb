require 'swagger_helper'

RSpec.describe 'planets', type: :request, capture_examples: true do
  path '/planets' do
    get('Retrieves all planets') do
      produces 'application/json'
      tags :planets

      response(200, 'Return all available planets') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/planet' }

        let!(:planet) { create(:plaanet) }
        run_test!
      end
    end
  end

  path '/planets/{id}' do
    get 'Retrieves a planet' do
      tags :planets
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Planet found' do
        schema '$ref' => '#/components/schemas/planet'

        let(:id) { create(:planet).id }
        run_test!
      end

      response '404', 'Not Found' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
