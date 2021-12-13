# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mining, type: :model do
  it 'should create a new mining' do
    mining = create(:mining)

    expect(mining.amount_requested).to eq(300)
  end

  it 'amount mined cant be less than 0' do
    expect do
      create(:mining, amount_requested: -100)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'executes a mining for the given amount 100' do
    mining = create(:mining, amount_requested: 100)
    resource = mining.resource

    expect(resource.current_amount).to eq(400)

    mining.execute

    expect(resource.current_amount).to eq(300)
    expect(mining.amount_mined).to eq(100)
  end

  it 'executes a mining for the given amount 400' do
    mining = create(:mining, amount_requested: 400)
    resource = mining.resource

    expect(resource.current_amount).to eq(400)

    mining.execute

    expect(resource.current_amount).to eq(0)
    expect(mining.amount_mined).to eq(400)
  end

  it 'executes a mining for the given amount 300' do
    resource = create(:resource, max_amount: 1000, current_amount: 600)
    mining = create(:mining, amount_requested: 300, resource: resource)

    expect(resource.current_amount).to eq(600)

    mining.execute

    expect(resource.current_amount).to eq(300)
    expect(mining.amount_mined).to eq(300)
  end

  it 'executes a mining for amount 0' do
    mining = create(:mining, amount_requested: 0)
    resource = mining.resource

    expect(resource.current_amount).to eq(400)

    mining.execute

    expect(resource.current_amount).to eq(400)
    expect(mining.amount_mined).to eq(0)
  end

  it 'executes a mining for an amount more than available' do
    mining = create(:mining, amount_requested: 600)
    resource = mining.resource

    mining.execute

    expect(resource.current_amount).to eq(0)
    expect(mining.amount_mined).to eq(400)
  end

  it 'throws an error when requested amount is less than 0' do
    expect do
      create(:mining, amount_requested: -100)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
