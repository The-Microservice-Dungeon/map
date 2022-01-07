# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameworld, type: :model do
  it 'publishes event on create' do
    expect(Kafka::Message).to receive(:publish)

    gameworld = Gameworld.new
    gameworld.save
    gameworld.publish_gameworld_created_event
  end
end
