require 'rails_helper'

RSpec.describe '/planets', type: :request do
  let(:valid_attributes) do
    gameworld = create(:gameworld)
    { 'movement_difficulty' => 0, 'recharge_multiplicator' => 0, 'planet_type' => 'default', 'x' => 0, 'y' => 0,
      'gameworld_id' => gameworld.id }
  end

  let(:invalid_attributes) do
    { 'movement_difficulty' => 0, 'recharge_multiplicator' => 0, 'planet_type' => 'default', 'x' => 0, 'y' => 0,
      'gameworld_id' => nil }
  end

  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Planet.create! valid_attributes
      get planets_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      planet = Planet.create! valid_attributes
      get planet_url(planet), as: :json
      expect(response).to be_successful
    end
  end
end
