require 'rails_helper'

RSpec.describe Exploration, type: :model do
  context 'execution' do
    it 'successfuly executes the exploration' do
      exploration = create(:exploration, transaction_id: '229c2ce1-2e96-4c99-a343-69c8906af192')

      expect(exploration.valid?).to be true
    end
  end
end
