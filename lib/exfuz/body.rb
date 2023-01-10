# frozen_string_literal: true

module Exfuz
  class Body
    def initialize(texts: [], top: 0, bottom: 10)
      @top = top
      @bottom = bottom

      @prev_row_to_text = {}

      @size = bottom - top + 1
      @texts = init_texts(texts)
      init_page(@texts, @size)
    end

    def move_next
      return if @current_page == @max_page

      @current_page += 1

      offset = (@current_page - 1) * @size
      next_texts = @texts.slice(offset, @size).each_with_index.each_with_object({}) do |(text, idx), result|
        result[idx] = text
      end
      change_some(next_texts)
    end

    def move_prev
      return if @current_page == 1

      @current_page -= 1

      offset = (@current_page - 1) * @size
      prev_texts = @texts.slice(offset, @size).each_with_index.each_with_object({}) do |(text, idx), result|
        result[idx] = text
      end
      change_some(prev_texts)
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
      @texts = init_texts(texts)
      @prev_row_to_text = @row_to_text
      init_page(texts, @size)
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

    def init_texts(texts)
      @texts = texts + [''] * (@size - (texts.size % @size))
    end

    def init_page(texts, size)
      @max_page = texts.size.zero? ? 1 : (texts.size.to_f / size).ceil
      @current_page = 1
      @row_to_text = texts.slice(0, size).each_with_index.each_with_object({}) do |(text, idx), result|
        result[row(idx)] = text
      end
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
