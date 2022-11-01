# frozen_string_literal: true

module Exfuz
  class Query
    attr_reader :line, :caret

    def initialize(caret)
      @chars = []
      @line = ''
      @caret = caret
    end

    def add(ch)
      insert(caret[1], ch)
      right
    end

    def delete
      return if caret[1].zero?

      remove(caret[1] - 1)
      left
    end

    def right
      return if @chars.size == @caret[1]

      @caret[1] += 1
    end

    def left
      return if @caret[1].zero?

      @caret[1] -= 1
    end

    private

    def insert(pos, ch)
      @chars.insert(pos, ch)
      @line = @chars * ''
    end

    def remove(pos)
      @chars.delete_at(pos)
      @line = @chars.clone.push(' ') * ''
    end
  end
end
