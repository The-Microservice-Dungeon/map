# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Planet, type: :model do
  let(:gameworld) { create(:gameworld) }

  before do
    allow(gameworld).to receive(:publish_gameworld_created_event).and_return(true)
  end

  it 'publishes event when creating a spacestation' do
    expect(Kafka::Message).to receive(:publish)

    planet = Planet.new(planet_type: 'spacestation', gameworld_id: gameworld.id)
    planet.save!
  end
end
