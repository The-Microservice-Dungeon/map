# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NeighboursController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/planets/1/neighbours').to route_to('neighbours#index', id: '1', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/planets/1/neighbours/1').to route_to('neighbours#show', id: '1', neighbour_id: '1', format: :json)
    end
  end
end
