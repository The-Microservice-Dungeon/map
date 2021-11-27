require 'rails_helper'

RSpec.describe ResourcesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/planets/1/resources').to route_to('resources#index', id: '1')
    end
  end
end
