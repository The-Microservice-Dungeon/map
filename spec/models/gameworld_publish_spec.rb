require 'rails_helper'

RSpec.describe Gameworld, type: :model do
  it 'publishes event on create' do
    expect(Kafka::Message).to receive(:publish)

    gameworld = Gameworld.new
    gameworld.save
  end
end
