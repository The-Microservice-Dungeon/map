require 'swagger_helper'

RSpec.describe 'explorations', type: :request, capture_examples: true do
  path '/planets/{planet_id}/explorations' do
    post 'Creates an exploration' do
      tags :explorations
      consumes 'application/json'
      produces 'application/json'
      parameter name: :planet_id, in: :path, type: :string
      parameter name: :exploration, in: :body, schema: {
        type: :object,
        properties: {
          exploration: { type: :object,
                         properties: {
                           transaction_id: { type: :string, format: :uuid }
                         }, required: %i[transaction_id] }
        },
        required: %w[exploration]
      }

      response '201', 'Created' do
        schema '$ref' => '#/components/schemas/exploration'

        let(:planet_id) { create(:planet).id }
        let(:exploration) { { exploration: { transaction_id: '229c2ce1-2e96-4c99-a343-69c8906af192' } } }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        schema '$ref' => '#/components/schemas/exploration'

        let(:planet_id) { create(:planet).id }
        let(:exploration) { { exploration: { transaction_id: 'NOUUID' } } }
        run_test!
      end

      response '400', 'Bad Request' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:planet_id) { create(:planet).id }
        let(:exploration) { { exploration: {} } }
        run_test!
      end
    end
  end
end
