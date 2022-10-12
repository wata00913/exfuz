# frozen_string_literal: true

module Exfuz
  class Candidate
    SEP = ':'
    def initialize(book:, sheet:, textable:)
      @book = book
      @sheet = sheet
      @textable = textable
    end

    def to_s(format: :default)
      path = File.expand_path(@book)
      [path, @sheet, @textable.position_s, @textable.value].join(SEP)
    end
  end
end
