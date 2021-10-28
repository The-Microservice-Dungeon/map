require 'rails_helper'

RSpec.describe SpawnCreation, type: :model do
  it 'should create a spawn creation' do
    spawn_creation = create(:spawn_creation)

    expect(spawn_creation).to be_truthy
    expect(spawn_creation.planet_id).to be_truthy
  end
end
