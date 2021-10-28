require 'rails_helper'

RSpec.describe Resource, type: :model do
  it 'a planet can have one resource of each resource type' do
    planet = create(:planet)
    coal = create(:resource_type, name: 'coal')
    iron = create(:resource_type, name: 'iron')
    gem = create(:resource_type, name: 'gem')
    gold = create(:resource_type, name: 'gold')
    platin = create(:resource_type, name: 'platin')

    r1 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type_id: coal.id)
    r2 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type_id: iron.id)
    r3 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type_id: gem.id)
    r4 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type_id: gold.id)
    r5 = Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type_id: platin.id)

    r1.save
    r2.save
    r3.save
    r4.save
    r5.save

    expect(planet.resources).to eq([r1, r2, r3, r4, r5])
  end

  it 'a planet can only have one resource of one resource type' do
    planet = create(:planet)
    coal = create(:resource_type, name: 'coal')

    Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id, resource_type_id: coal.id).save
    expect do
      Resource.new(max_amount: 1000, current_amount: 400, planet_id: planet.id,
                   resource_type_id: coal.id).save
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it 'executes a mining for the given amount 100' do
    resource = create(:resource)
    expect(resource.current_amount).to eq(400)

    mining = resource.execute_mining(100)

    expect(resource.current_amount).to eq(300)
    expect(mining.amount_mined).to eq(100)
  end

  it 'executes a mining for the given amount 400' do
    resource = create(:resource)
    expect(resource.current_amount).to eq(400)

    mining = resource.execute_mining(400)

    expect(resource.current_amount).to eq(0)
    expect(mining.amount_mined).to eq(400)
  end

  it 'executes a mining for the given amount 300' do
    resource = create(:resource, max_amount: 1000, current_amount: 600)
    expect(resource.current_amount).to eq(600)

    mining = resource.execute_mining(300)

    expect(resource.current_amount).to eq(300)
    expect(mining.amount_mined).to eq(300)
  end

  it 'executes a mining for amount 0' do
    resource = create(:resource)
    expect(resource.current_amount).to eq(400)

    mining = resource.execute_mining(0)

    expect(resource.current_amount).to eq(400)
    expect(mining.amount_mined).to eq(0)
  end

  it 'executes a mining for an amount more than available' do
    resource = create(:resource)
    expect(resource.current_amount).to eq(400)

    mining = resource.execute_mining(600)

    expect(resource.current_amount).to eq(0)
    expect(mining.amount_mined).to eq(400)
  end

  it 'executes mining for negative amount as 0' do
    resource = create(:resource)
    expect(resource.current_amount).to eq(400)

    mining = resource.execute_mining(-100)

    expect(resource.current_amount).to eq(400)
    expect(mining.amount_mined).to eq(0)
  end

  it 'replenishes the resource' do
    resource = create(:resource, current_amount: 400, max_amount: 1000)

    resource.replenish!(400)

    expect(resource.current_amount).to eq(800)
  end

  it 'replenishes the resource to the maximum amount' do
    resource = create(:resource, current_amount: 400, max_amount: 1000)

    resource.replenish!(2000)

    expect(resource.current_amount).to eq(1000)
  end
end
