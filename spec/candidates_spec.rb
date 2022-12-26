RSpec.describe Exfuz::Candidate do
  describe 'filter' do
    b1 = Exfuz::BookName.new('./spec/test_data/data.xlsx')
    s1 = Exfuz::SheetName.new('Sheet1')
    s2 = Exfuz::SheetName.new('Sheet2')
    c1 = Exfuz::Cell.new(address: '$D$5', value: 'This is test data')
    c2 = Exfuz::Cell.new(address: '$D$5', value: 'This is test')
    c3 = Exfuz::Cell.new(address: '$D$5', value: 'This is test data')

    p1 = Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s1 }, { textable: c1 }])
    p2 = Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s1 }, { textable: c2 }])
    p3 = Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s2 }, { textable: c3 }])

    candidates = Exfuz::Candidates.new
    # デッドロック(メインスレッドのみの起動であるが)を防ぐためにnilを追加
    [p1, p2, p3, nil].each { |p| candidates.push(p) }
    it 'when sheet_name=Sheet1 & textable=data, filter one record' do
      filtered_p = candidates.filter({ sheet_name: 'Sheet1', textable: 'data' }).positions

      expect(filtered_p).to match([p1])
    end

    it 'when sheet_name=Sheet1, filter two record and when textable=data, filter one record' do
      filtered_p = candidates.filter({ sheet_name: 'Sheet1' })
                             .filter({ textable: 'data' })
                             .positions

      expect(filtered_p).to match([p1])
    end

    it 'when textable=data, filter two record' do
      filtered_p = candidates.filter({ textable: 'data' }).positions

      expect(filtered_p).to match([p1, p3])
    end
  end
end
