RSpec.describe Exfuz::Jump do
  b1 = Exfuz::BookName.new('./spec/test_data/data.xlsx')
  b2 = Exfuz::BookName.new('./spec/test_data/test.xlsx')
  s1 = Exfuz::SheetName.new('Sheet1')
  s2 = Exfuz::SheetName.new('Sheet2')
  c1 = Exfuz::Cell.new(address: '$D$5', value: 'This is test data')
  c2 = Exfuz::Cell.new(address: '$D$5', value: 'This is test')
  c3 = Exfuz::Cell.new(address: '$D$5', value: 'This is test data')

  p1 = Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s1 }, { textable: c1 }])
  p2 = Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s1 }, { textable: c2 }])
  p3 = Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s2 }, { textable: c3 }])
  p4 = Exfuz::Position.new([{ book_name: b2 }, { sheet_name: s1 }, { textable: c3 }])
  describe 'list' do
    it 'return s1, s2 positions when jump sheet' do
      jumping_sheet_positions = [
        Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s1 }]),
        Exfuz::Position.new([{ book_name: b1 }, { sheet_name: s2 }]),
        Exfuz::Position.new([{ book_name: b2 }, { sheet_name: s1 }])
      ]
      jump = Exfuz::Jump.new(jumping_sheet_positions)
      jump.run
    end
  end
end
