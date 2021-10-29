require 'swagger_helper'

RSpec.describe 'gameworlds', type: :request, capture_examples: true do
  path '/gameworlds' do
    get('Retrieves all gameworlds') do
      produces 'application/json'
      tags :gameworlds

      response(200, 'Return all available gameworlds') do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/gameworld' }

        let!(:gameworld) { create(:gameworld) }
        run_test!
      end
    end

    post 'Creates a gameworld' do
      tags :gameworlds
      consumes 'application/json'
      produces 'application/json'
      parameter name: :gameworld, in: :body, schema: {
        type: :object,
        properties: {
          gameworld: { type: :object,
                       properties: {
                         player_amount: { type: :integer, minimum: 1 },
                         round_amount: { type: :integer, minimum: 1 }
                       }, required: %i[player_amount round_amount] }
        },
        required: %w[gameworld]
      }

      response '201', 'Created' do
        schema '$ref' => '#/components/schemas/gameworld'

        let(:gameworld) { { gameworld: { player_amount: 100, round_amount: 100 } } }
        run_test!
      end

      response '400', 'Bad Request' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:gameworld) { { player_amount: 100 } }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        schema '$ref' => '#/components/schemas/errors_object'

        let(:gameworld) { { gameworld: { player_amount: 100, round_amount: -100 } } }
        run_test!
      end
    end
  end

  path '/gameworlds/{id}' do
    get 'Retrieves a gameworld' do
      tags :gameworlds
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Gameworld found' do
        schema '$ref' => '#/components/schemas/gameworld'

        let(:id) { create(:gameworld).id }
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
