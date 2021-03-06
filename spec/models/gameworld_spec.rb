# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gameworld, type: :model do
  it 'should set status to inactive as default' do
    gameworld = Gameworld.new
    gameworld.save

    expect(gameworld.status).to eq('active')
  end
end
