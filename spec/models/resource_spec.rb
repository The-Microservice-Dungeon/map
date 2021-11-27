require 'rails_helper'

RSpec.describe Resource, type: :model do
  it 'a planet can have one resource of each resource type' do
    planet = create(:planet)

    r1 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'coal')
    r2 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'iron')
    r3 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'gem')
    r4 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'gold')
    r5 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'platin')

    r1.save
    r2.save
    r3.save
    r4.save
    r5.save

    expect(planet.resources).to eq([r1, r2, r3, r4, r5])
  end

  # TODO
  xit 'a planet can only have one resource' do
    planet = create(:planet)

    Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type: 'coal').save
    expect do
      Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id,
                   resource_type: 'coal').save
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
