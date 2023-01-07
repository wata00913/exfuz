# frozen_string_literal: true

require 'unicode/display_width'
require 'unicode/display_width/string_ext'

module Exfuz
  class Query
    attr_reader :line, :caret

    MAX_UTF_8_BYTES = 3

    def initialize(caret)
      @chars = []
      @line = ''
      @caret = caret
      @offset = caret[1]
    end

    def text
      @chars.join
    end

    def add(ch_or_chs)
      if ch_or_chs.instance_of?(Array)
        ch_or_chs.each do |ch|
          insert_at_caret(ch)
          right
        end
      elsif ch_or_chs.instance_of?(String)
        insert_at_caret(ch_or_chs)
        right
      end
    end

    def delete
      return if left_end?(@caret[1])

      left
      remove_at_caret
    end

    def right(direction = 1)
      col = 0

      col += 1 while direction > col && next_caret
    end

    def left(direction = 1)
      col = 0

      col += 1 while direction > col && prev_caret
    end

    private

    # ['あ', nil]
    # caret 0 -> 2 (right end)
    def next_caret
      return if right_end?(@caret[1])

      idx = current - @offset
      idx += 1 while idx < @chars.size - 1 && @chars[idx + 1].nil?
      @caret[1] = @offset + idx + 1
    end

    # ['あ', nil]
    # caret 2 -> 0 (left end)
    def prev_caret
      return if left_end?(@caret[1])

      idx = current - @offset
      idx -= 1 while !idx.zero? && @chars[idx - 1].nil?
      @caret[1] = @offset + idx - 1
    end

    def insert_at_caret(ch)
      r_arr = @chars.slice!((current - @offset)..-1)
      @chars.concat([ch] + [nil] * (ch.display_width - 1) + r_arr)
      @line = @chars * ''
    end

    # [a, あ, nil, い, nil] -> [a, い, nil]
    # caret 1 -> 0
    def remove_at_caret
      r_arr = @chars.slice!((current - @offset)..-1)
      deleted = r_arr.delete_at(0)
      @chars.concat(r_arr.drop_while(&:nil?))
      @line = @chars.clone.push(' ' * deleted.display_width) * ''
    end

    def current
      @caret[1]
    end

    def left_end?(col)
      @offset == col
    end

    def right_end?(col)
      @chars.size + @offset == col
    end
  end
end
