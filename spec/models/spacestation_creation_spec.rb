# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpacestationCreation, type: :model do
  it 'creates a new spacestation_creation' do
    spacestation_creation = create(:spacestation_creation)
    expect(spacestation_creation.id).to be_truthy
    expect(spacestation_creation.planet_id).to be_truthy
  end
end
