RSpec.describe Exfuz::Candidate do
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

  describe 'filter' do
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

  describe 'group_by' do
    # オブジェクトをグルーピングさせるための属性が必要
    # sheet_name: [ position['Sheet1']: p1,
    #               position['Sheet2']: p2, p3 ]
    # group_by([:book_name, :sheet_name], flatten)
    # [book_name:, :sheet_name]: [ position['data.xlsx', 'Sheet1']: p1,
    #                              position['data.xlsx', 'Sheet2']: p2, p3]]
    # group_by([:book_name, :sheet_name])
    # book_name: [ position['data.xlsx']:
    #              sheet_name: { 
    #                            position['data.xlsx', 'Sheet1']: [p1],
    #                            position['data.xlsx', 'Sheet2']: [p2, p3]
    #                          }
    describe 'group by sheet_name' do
      it 'grouping position is Sheet1, Sheet2' do
        expected = [
          Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s1 }]),
          Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s2 }])
        ]

        group = candidates.group_by([:sheet_name])
        p = group.positions(:sheet_name)
        expect(p).to match(expected)
      end
    end
    describe 'group by book_name, sheet_name in hierarchy' do
      it 'grouping position is book1: [Sheet1, Sheet2]' do
        grouping_book_name_positions = [Exfuz::Position.new([{ book_name: b1 }])]
        grouping_sheet_name_positions = [
          Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s1 }]),
          Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s2 }])
        ]
        group = candidates.group_by(%i[book_name sheet_name])
        gbp = group.positions(:book_name)
        gsp = group.positions(:sheet_name)

        expect(gbp).to match(grouping_book_name_positions)
        expect(gsp).to match(grouping_sheet_name_positions)
      end
    end
  end
end
