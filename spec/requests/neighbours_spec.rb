require 'swagger_helper'

RSpec.describe 'neighbours', type: :request, capture_examples: true do
  path '/planets/{id}/neighbours' do
    get('Retrieves all neighbours') do
      produces 'application/json'
      tags :neighbours
      parameter name: :id, in: :path, type: :string

      response(200, 'Return all available neighbours') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/planet' }

        let(:id) do
          planet = create(:planet)
          neighbour = create(:planet)
          planet.add_neighbour(neighbour)
          planet.id
        end
        run_test!
      end
    end
  end

  path '/planets/{id}/neighbours/{neighbour_id}' do
    get 'Retrieves a planets neighbour' do
      tags :neighbours
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :neighbour_id, in: :path, type: :string

      response '200', 'Neighbour found' do
        schema '$ref' => '#/components/schemas/planet'

        let(:planet) { create(:planet) }
        let(:neighbour) do
          neighbour = create(:planet)
          planet.add_neighbour(neighbour)
          neighbour
        end
        let(:id) { planet.id }
        let(:neighbour_id) { neighbour.id }
        run_test!
      end

      response '404', 'Not Found' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:id) { 'invalid' }
        let(:neighbour_id) { 'invalid' }
        run_test!
      end
    end
  end
end
