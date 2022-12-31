RSpec.describe Exfuz::Parser do
  let(:data_path) { File.absolute_path('./spec/test_data/data.xlsx') }
  describe 'parse' do
    let(:book_name) { data_path }
    it 'recognizes book name, sheets' do
      parser = Exfuz::Parser.new(data_path)

      parser.parse
      expect(parser.book_name).to eq File.expand_path(data_path, __FILE__)
      expect(parser.sheet_names).to eq(%w[Sheet1 Sheet2])
    end
  end

  describe 'each_cell_with_all' do
    it 'recognizes all info' do
      parser = Exfuz::Parser.new(data_path)
      parser.parse

      expected = [
        { book_name: data_path, sheet_name: 'Sheet1', cell: '$B$2', value: 'Sheet1' },
        { book_name: data_path, sheet_name: 'Sheet1', cell: '$C$3', value: 'Test Data' },
        { book_name: data_path, sheet_name: 'Sheet1', cell: '$D$4', value: 'Hello' },
        { book_name: data_path, sheet_name: 'Sheet1', cell: '$D$5', value: 'This is test data' },

        { book_name: data_path, sheet_name: 'Sheet2', cell: '$B$2', value: 'Sheet2' },
        { book_name: data_path, sheet_name: 'Sheet2', cell: '$C$3', value: 'Test Data1' },
        { book_name: data_path, sheet_name: 'Sheet2', cell: '$D$4', value: 'Good evening' },
        { book_name: data_path, sheet_name: 'Sheet2', cell: '$D$5', value: 'This is test data of Sheet2' },
        { book_name: data_path, sheet_name: 'Sheet2', cell: '$D$7', value: 'Test Data2' },
        { book_name: data_path, sheet_name: 'Sheet2', cell: '$E$8', value: 'excel fuzzy finder' },
        { book_name: data_path, sheet_name: 'Sheet2', cell: '$E$9',
          value: 'Fuzzy finder excel. This uses a fuzzy finder such as peco or fzf.' }
      ]

      cell_data = []
      parser.each_cell_with_all do |cell|
        cell_data << cell
      end

      expect(cell_data).to eq expected
    end
  end
end
