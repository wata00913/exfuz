# frozen_string_literal: true

module Exfuz
  class Cell
    attr_reader :row, :col, :value

    def initialize(value:, row: nil, col: nil, address: nil)
      if row && col
        @row = row
        @col = col
      elsif address
        @row, @col = to_idx(address)
      else
        raise "argument error. row: #{row}, col: #{col}, address: #{address}"
      end

      @value = value
    end

    def position_s(format: :default)
      to_address(@col, row)
    end

    private

    def to_idx(address)
      _, c_alph, r_str = address.split('$')

      c = 0
      large_a_z = ('A'..'Z')
      c_alph.chars.reverse.each_with_index do |char, i|
        c += (26**i * (large_a_z.find_index(char) + 1))
      end

      [r_str.to_i, c]
    end

    def to_address(col, row)
      "$#{to_alphabet(col)}$#{row}"
    end

    def to_alphabet(idx)
      large_a_z = ('A'..'Z').to_a
      alphabet = ''
      q = idx

      until q.zero?
        q, r = (q - 1).divmod(26)
        alphabet += large_a_z[r]
      end

      alphabet
    end
  end
end