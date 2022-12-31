# frozen_string_literal: true

RSpec.describe Exfuz::Cell do
  describe 'to_idx' do
    it 'address convert to row idx and col idx' do
      c = Exfuz::Cell.new(address: '$BC$10', value: 'hoge')
      expect([c.row, c.col]).to eq([10, 55])
    end
  end

  describe '==' do
    it 'equal if form of path is different' do
      c1 = Exfuz::Cell.new(address: '$BC$10', value: 'hoge')
      c2 = Exfuz::Cell.new(row: 10, col: 55, value: 'hoge')
      expect(c1 == c2).to eq(true)
    end
  end
end
