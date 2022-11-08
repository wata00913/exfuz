# frozen_string_literal: true

module Exfuz
  class Candidates
    def initialize(items = [])
      @items = {}
      @idx = 0
      items.each_with_index do |item, idx|
        @items[idx + 1] = item
      end
    end

    def push(item)
      @idx += 1
      @items[@idx] = item
    end

    def each_by_filter(word = '', attr: :value)
      regexp = Regexp.new(word)
      @items.each do |k, v|
        if word.empty?
          yield k, v
        elsif v.method(attr).call =~ regexp
          yield k, v
        end
      end
    end
  end
end
