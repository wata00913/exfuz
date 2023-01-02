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

  describe 'slice' do
    b = Exfuz::BookName.new('./spec/test_data/data.xlsx')
    s = Exfuz::SheetName.new('Sheet1')
    c = Exfuz::Cell.new(address: '$C$3', value: 'Test Data')
    context 'when position is book_name, sheet_name, textable and slice [book_name, sheet_name]' do
      it 'return position [book_name, sheet_name]' do
        expected = Exfuz::Position.new([{ book_name: b }, { sheet_name: s }])
        p = Exfuz::Position.new([{ book_name: b }, { sheet_name: s }, { textable: c }])
        sliced_p = p.slice(:sheet_name)

        expect(sliced_p).to eq(expected)
      end
    end
  end

  describe 'jump_info', unless: Exfuz::Util.wsl? do
    relative_path = './spec/test_data/data.xlsx'
    b = Exfuz::BookName.new(relative_path)
    s = Exfuz::SheetName.new('Sheet1')
    c = Exfuz::Cell.new(address: '$C$5', value: 'Test Data')
    bp = Exfuz::Position.new([{ book_name: b }])
    cp = Exfuz::Position.new([{ book_name: b }, { sheet_name: s }, { textable: c }])
    it 'return book name when destination is book' do
      expect(bp.jump_info).to eq(
        { book_name: File.absolute_path(relative_path) }
      )
    end
    it 'return book path, sheet name, cell index when destination is textable' do
      expect(cp.jump_info).to eq(
        {
          book_name: File.absolute_path(relative_path),
          sheet_name: 'Sheet1',
          textable: { row: 5, col: 3 }
        }
      )
    end
  end
end
