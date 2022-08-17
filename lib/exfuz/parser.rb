require 'xsv'

module Exfuz
  class Parser
    EXTENSIONS = ['.xlsx', '.xls', '.xlsm'].freeze

    attr_reader :sheet_names

    def initialize(path)
      raise 'not exsits file' unless File.exist?(path)

      extname = File.extname(path)
      raise 'no match extension name' unless EXTENSIONS.include?(extname)

      @absolute_path = File.absolute_path(path)
      @book = nil
      @sheet_names = []
    end

    def parse
      @book = Xsv.open(@absolute_path)
      @sheet_names = @book.sheets.map { |s| s.name.force_encoding(Encoding::UTF_8) }
    end

    def book_name
      @absolute_path
    end

    def each_cell_with_all
      @book.sheets.each do |sheet|
        sheet_name = sheet.name
        sheet.each_with_index do |row, r_i|
          row.each_with_index do |val, c_i|
            next if val.nil?

            cell = {
              book_name: book_name,
              sheet_name: sheet_name,
              cell: to_address(r_i + 1, c_i + 1),
              value: val
            }
            yield cell
          end
        end
      end
    end

    private

    def to_address(r_idx, c_idx)
      "$#{to_alphabet(c_idx)}$#{r_idx}"
    end

    def to_alphabet(idx)
      large_a_z = ('A'..'Z').to_a
      alphabet = ''
      q = idx

      until q.zero?
        q, r = (q - 1).divmod(26)
        alphabet.concat(large_a_z[r])
      end

      alphabet
    end
  end
end
