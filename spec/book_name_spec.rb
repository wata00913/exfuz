# frozen_string_literal: true

RSpec.describe Exfuz::BookName do
  describe '==' do
    it 'equal if form of path is different' do
      b1 = Exfuz::BookName.new('./test_data/data.xlsx')
      b2 = Exfuz::BookName.new(File.absolute_path('./test_data/data.xlsx'))
      expect(b1 == b2).to eq(true)
    end
  end

  describe 'relative_path' do
    it 'return relative_path' do
      b = Exfuz::BookName.new(File.absolute_path('./test_data/data.xlsx'))
      expect(b.relative_path == 'test_data/data.xlsx').to eq(true)
    end
  end
end
