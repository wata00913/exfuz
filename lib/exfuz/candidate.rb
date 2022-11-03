# frozen_string_literal: true

require 'pathname'

module Exfuz
  class Candidate
    def initialize(book_name:, sheet_name:, textable:)
      @book_name = book_name
      @sheet_name = sheet_name
      @textable = textable
    end

    def to_line
      @conf ||= Exfuz::Configuration.instance
      [
        book_name_line,
        @sheet_name,
        textable_position_line,
        value_line
      ].join(@conf.line_sep)
    end

    private

    def book_name_line
      pname = Pathname.new(@book_name)
      case @conf.book_name_path_type
      when :relative
        pname.relative_path_from(@conf.dirname.to_s)
      when :absolute
        @book_name
      end
    end

    def textable_position_line
      @textable.position_s(format: @conf.cell_position_format)
    end

    def value_line
      text = @textable.value.to_s
      @conf.split_new_line ? text : text.gsub(/\R+/) { '\n' }
    end
  end
end
