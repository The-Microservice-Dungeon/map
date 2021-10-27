require 'rails_helper'

RSpec.describe '/resources', type: :request do
  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      resource = create(:resource)
      get resources_url(resource.planet), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      resource = create(:resource)
      get resource_url(resource.planet, resource), as: :json
      expect(response).to be_successful
    end
  end
end
