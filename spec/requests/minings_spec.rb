require 'rails_helper'

RSpec.describe '/minings', type: :request do
  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      mining = create(:mining)
      get minings_url(mining.planet), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    it 'creates a new mining' do
      resource = create(:resource)
      resource_type = resource.resource_type.name
      post minings_url(resource.planet), params: { mining: { resource_type: resource_type, amount_mined: 100 } },
                                         headers: valid_headers, as: :json
      expect(response).to have_http_status(:created)
    end

    it 'fails when given a negative amount' do
      resource = create(:resource)
      resource_type = resource.resource_type.name
      expect do
        post minings_url(resource.planet), params: { mining: { resource_type: resource_type, amount_mined: -100 } },
                                           headers: valid_headers, as: :json
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'fails when given resource type is not existent' do
      resource = create(:resource)
      resource_type = 'obsidian'
      expect do
        post minings_url(resource.planet), params: { mining: { resource_type: resource_type, amount_mined: 100 } },
                                           headers: valid_headers, as: :json
      end.to raise_error(ActiveRecord::StatementInvalid)
    end

    it 'fails when given planet is not existent' do
      resource = create(:resource)
      resource_type = resource.resource_type.name
      expect do
        post minings_url({ id: 'test' }), params: { mining: { resource_type: resource_type, amount_mined: 100 } },
                                          headers: valid_headers, as: :json
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
