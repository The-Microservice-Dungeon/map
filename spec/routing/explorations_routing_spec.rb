require 'rails_helper'

RSpec.describe ExplorationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/planets/1/explorations').to route_to('explorations#create', planet_id: '1', format: :json)
    end
  end
end
