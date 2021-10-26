require 'rails_helper'

RSpec.describe '/resource_types', type: :request do
  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      resource_type = create(:resource_type)

      get resource_types_url(resource_type), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end
end
