# frozen_string_literal: true

RSpec.describe Exfuz::Candidate do
  let(:data_path) { File.absolute_path('./spec/test_data/data.xlsx') }
  describe to_s do
    it 'by default format' do
      cell = Exfuz::Cell.new(row: 2, col: 2, value: 'Sheet1')

      candidate = Exfuz::Candidate.new(book: './spec/test_data/data.xlsx',
                                       sheet: 'Sheet1',
                                       textable: cell)
      expect(candidate.to_s).to eq("#{data_path}:Sheet1:$B$2:Sheet1")
    end
  end
end
