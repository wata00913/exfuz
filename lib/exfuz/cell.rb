# frozen_string_literal: true

module Exfuz
  class Cell
    attr_reader :row, :col, :value

    def initialize(row:, col:, value:)
      @row = row
      @col = col
      @value = value
    end

    def position_s(format: :default)
      "$#{to_alphabet(@col)}$#{@row}"
    end

    private

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
