require 'rails_helper'

RSpec.describe Replenishment, type: :model do
  it 'creates a new replenishment' do
    replenishment = create(:replenishment)

    expect(replenishment).to be_truthy
  end
end
