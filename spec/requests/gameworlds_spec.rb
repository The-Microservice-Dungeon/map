require 'rails_helper'

RSpec.describe '/gameworlds', type: :request do
  let(:valid_attributes) do
    { 'player_amount' => 100, 'round_amount' => 1000 }
  end

  let(:invalid_attributes) do
    { 'player_amount' => -100, 'round_amount' => -1000 }
  end

  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Gameworld.create!
      get gameworlds_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      gameworld = Gameworld.create!
      get gameworld_url(gameworld), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Gameworld' do
        expect do
          post gameworlds_url,
               params: { gameworld: valid_attributes }, headers: valid_headers, as: :json
        end.to change(Gameworld, :count).by(1)
      end

      it 'renders a JSON response with the new gameworld' do
        post gameworlds_url,
             params: { gameworld: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Gameworld' do
        expect do
          post gameworlds_url,
               params: { gameworld: invalid_attributes }, as: :json
        end.to change(Gameworld, :count).by(0)
      end

      it 'renders a JSON response with errors for the new gameworld' do
        post gameworlds_url,
             params: { gameworld: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
