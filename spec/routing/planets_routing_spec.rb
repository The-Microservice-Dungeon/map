require 'rails_helper'

RSpec.describe PlanetsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/planets').to route_to('planets#index')
    end

    it 'routes to #show' do
      expect(get: '/planets/1').to route_to('planets#show', id: '1')
    end
  end
end
