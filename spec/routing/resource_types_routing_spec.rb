require 'rails_helper'

RSpec.describe ResourceTypesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/resource_types').to route_to('resource_types#index')
    end
  end
end
