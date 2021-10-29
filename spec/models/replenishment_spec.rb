require 'rails_helper'

RSpec.describe Replenishment, type: :model do
  it 'replenishes the resource' do
    resource = create(:resource, max_amount: 1000, current_amount: 400)
    replenishment = create(:replenishment, resource: resource)

    replenishment.execute_replenishment

    expect(replenishment.amount_replenished).to eq(600)
    expect(replenishment.resource.current_amount).to eq(1000)
  end
end
