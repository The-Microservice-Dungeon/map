require 'rails_helper'

RSpec.describe ResourcesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/planets/1/resources').to route_to('resources#index', id: '1')
    end

    it 'routes to #show' do
      expect(get: '/planets/1/resources/1').to route_to('resources#show', id: '1', resource_id: '1')
    end
  end
end
