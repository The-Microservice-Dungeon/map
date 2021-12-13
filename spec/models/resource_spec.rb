# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource, type: :model do
  it 'a planet can have one resource' do
    planet = create(:planet)
    resource = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'coal')
    resource.save!
    expect(planet.resource).to eq(resource)
  end

  it 'a planet can only have one resource' do
    planet = create(:planet)

    Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'coal').save
    expect do
      Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id,
                   resource_type: 'coal').save
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
