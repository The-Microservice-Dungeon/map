require 'rails_helper'

RSpec.describe Mining, type: :model do
  it 'should create a new mining' do
    mining = create(:mining)

    expect(mining.amount_mined).to eq(100)
  end

  it 'amount mined cant be 0 or less' do
    expect do
      create(:mining, amount_mined: 0)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
