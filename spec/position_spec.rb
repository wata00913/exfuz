RSpec.describe Exfuz::Position do
  describe 'match?' do
    it 'return true' do
      position = Exfuz::Position.new([{ book_name: Exfuz::BookName.new('./spec/test_data/data.xlsx') },
                                      { sheet_name: Exfuz::SheetName.new('Sheet1') },
                                      { textable: Exfuz::Cell.new(address: '$C$3', value: 'Test Data') }])

      result = position.match?({ sheet_name: 'Sheet1', textable: 'data' })
      expect(result).to eq(true)
    end
  end

  describe 'hash key' do
    b = Exfuz::BookName.new('./spec/test_data/data.xlsx')
    s = Exfuz::SheetName.new('Sheet1')
    it 'return true when equivalence' do
      p1 = Exfuz::Position.new([{ book_name: b }, { sheet_name: s }])
      p2 = Exfuz::Position.new([{ book_name: b }, { sheet_name: s }])

      expect(p1.hash).to eq(p2.hash)
      expect(p1.eql?(p2)).to eq(true)
    end
    it 'return false when different order' do
      p1 = Exfuz::Position.new([{ sheet_name: s }, { book_name: b }])
      p2 = Exfuz::Position.new([{ book_name: b }, { sheet_name: s }])

      expect(p1.hash).not_to eq(p2.hash)
      expect(p1.eql?(p2)).not_to eq(true)
    end
  end
end
