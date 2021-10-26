require 'rails_helper'

RSpec.describe ResourceType, type: :model do
  it 'creates a new resource_type coal' do
    resource_type = ResourceType.new(name: 'coal')
    resource_type.save

    expect(resource_type.name).to eq('coal')
    expect(resource_type.difficulty).to eq(0)
  end

  it 'creates a new resource_type iron' do
    resource_type = ResourceType.new(name: 'iron', difficulty: 1)
    resource_type.save

    expect(resource_type.name).to eq('iron')
    expect(resource_type.difficulty).to eq(1)
  end
end
