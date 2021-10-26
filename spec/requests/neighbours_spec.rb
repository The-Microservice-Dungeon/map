require 'rails_helper'

RSpec.describe '/planets/:id/neighbours', type: :request do
  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      planet = create(:planet)
      neighbour = create(:planet)

      planet.add_neighbour(neighbour)

      get neighbours_url(planet), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      planet = create(:planet)
      neighbour = create(:planet)

      planet.add_neighbour(neighbour)

      get neighbour_url(planet, neighbour), as: :json
      expect(response).to be_successful
    end

    it 'renders a not found error' do
      planet = create(:planet)
      neighbour = create(:planet)

      get neighbour_url(planet, neighbour), as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
