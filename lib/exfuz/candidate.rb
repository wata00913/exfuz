# frozen_string_literal: true

module Exfuz
  class Candidate
    SEP = ':'
    def initialize(book_name:, sheet_name:, textable:)
      @book_name = book_name
      @sheet_name = sheet_name
      @textable = textable
    end

    def to_s(format: :default)
      path = File.expand_path(@book_name)
      [path, @sheet_name, @textable.position_s, @textable.value].join(SEP)
    end
  end
end
