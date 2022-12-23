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
end
