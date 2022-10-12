# frozen_string_literal: true

RSpec.describe Exfuz::Cell do
  describe 'to_idx' do
    it 'address convert to row idx and col idx' do
      c = Exfuz::Cell.new(address: '$BC$10', value: 'hoge')
      expect([c.row, c.col]).to eq([10, 55])
    end
  end
end

