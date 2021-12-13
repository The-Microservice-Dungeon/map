# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameworldsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/gameworlds').to route_to('gameworlds#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/gameworlds/1').to route_to('gameworlds#show', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/gameworlds').to route_to('gameworlds#create', format: :json)
    end
  end
end
