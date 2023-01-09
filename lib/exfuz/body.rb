# frozen_string_literal: true

module Exfuz
  class Body
    def initialize(texts: [], top: 0, bottom: 10)
      @top = top
      @bottom = bottom
      @texts = texts
      @prev_row_to_text = {}

      @size = bottom - top + 1
      @row_to_text = @texts.slice(0, @size).each_with_index.each_with_object({}) do |(text, idx), result|
        result[idx + @top] = text
      end
    end

    def change(texts)
      change_some(texts)
    end

    def change_some(texts)
      texts.each do |line_num, text|
        @prev_row_to_text[row(line_num)] = @row_to_text[row(line_num)] if @row_to_text.key?(row(line_num))
        @row_to_text[row(line_num)] = text
      end
    end

    def change_all(texts)
      @prev_row_to_text = @row_to_text
      @row_to_text = texts.each_with_object({}) do |(idx, text), result|
        result[row(idx)] = text
      end
    end

    def lines(overwrite: false)
      return @row_to_text unless overwrite

      overwrite_lines = @prev_row_to_text.each_with_object({}) do |(row, prev_text), result|
        current_text = @row_to_text[row] || ''
        result[row] = overwrite(current: current_text, prev: prev_text)
      end

      @row_to_text.merge(overwrite_lines)
    end

    def clear_prev
      @prev_row_to_text = {}
    end

    private

    def row(idx)
      idx + @top
    end

    def overwrite(current:, prev:)
      if current.size < prev.size
        current.ljust(prev.size)
      else
        current
      end
    end
  end
end
