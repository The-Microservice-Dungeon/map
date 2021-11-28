require 'swagger_helper'

RSpec.describe 'planets', type: :request, capture_examples: true do
  path '/planets' do
    get('Retrieves all planets') do
      produces 'application/json'
      parameter name: :planet_type, in: :query, schema: { type: :string }, description: 'Optional, planet type'
      parameter name: :taken, in: :query, schema: { type: :boolean },
                description: 'Optional, if the planet/spawn is already taken'
      tags :planets

      response(200, 'Return all available planets for the active gameworld') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/planet' }

        let!(:planet) { create(:planet) }
        let(:taken) {}
        let(:planet_type) {}
        run_test!
      end
    end
  end

  path '/planets/{planet_id}' do
    get 'Retrieves a planet' do
      tags :planets
      produces 'application/json'
      parameter name: :planet_id, in: :path, schema: { type: :string, format: :uuid }

      response '200', 'Planet found' do
        schema '$ref' => '#/components/schemas/planet'

        let(:planet_id) { create(:planet).id }
        run_test!
      end

      response '404', 'Not Found' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:planet_id) { 'invalid' }
        run_test!
      end
    end

    patch 'Set the taken_at field of a planet/spawn' do
      tags :planets
      description 'Set the taken_at field of the planet to the given timestamp or null'
      consumes 'application/json'
      produces 'application/json'
      description
      parameter name: :planet_id, in: :path, schema: { type: :string, format: :uuid }
      parameter name: :planet, in: :body, schema: {
        type: :object,
        properties: {
          planet: { type: :object,
                    properties: { taken_at: { type: :string, format: 'date-time' } }, required: %i[taken_at] }
        },
        required: %w[planet]
      }

      response '200', 'Taken at updated' do
        schema '$ref' => '#/components/schemas/planet'

        let(:planet_id) { create(:planet).id }
        let(:planet) { { planet: { taken_at: Time.now.to_s } } }
        run_test!
      end
    end
  end
end
