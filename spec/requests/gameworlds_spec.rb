require 'swagger_helper'

RSpec.describe 'gameworlds', type: :request, capture_examples: true do
  path '/gameworlds' do
    get('Retrieves all gameworlds') do
      produces 'application/json'
      tags :gameworlds

      response(200, 'Return all available gameworlds') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :string, format: :uuid },
                   status: { type: :string, enum: %w[active inactive] },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 },
                 required: %w[id status created_at updated_at]
               }

        let!(:gameworlds) do
          3.times do
            create(:gameworld)
          end
        end
        run_test!
      end
    end
  end

  path '/gameworlds/{id}' do
    get 'Retrieves a gameworld' do
      tags :gameworlds
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'gameworld found' do
        schema type: :object,
               properties: {
                 id: { type: :string, format: :uuid },
                 status: { type: :string, enum: %w[active inactive] },
                 planets: {
                   type: :array,
                   items: {
                     id: { type: :string, format: :uuid }
                   }
                 },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id status planets created_at updated_at]

        let(:id) { create(:gameworld).id }
        run_test!
      end

      response '404', 'Gameworld not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
