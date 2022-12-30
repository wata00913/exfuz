# frozen_string_literal: true

module Exfuz
  class Candidates
    @@queue = Queue.new
    @@raw = []

    def initialize(items = [])
      @items = {}
      @idx = 0
      items.each_with_index do |item, idx|
        @items[idx + 1] = item
      end

      @processed = items
    end

    def push(item)
      @idx += 1
      @items[@idx] = item
      @@queue << item
    end

    def close_push?
      @@queue.closed?
    end

    def close_push
      @@queue << nil
    end

    def positions
      @processed.empty? ? @@raw : @processed
    end

    def filter(conditions)
      pipeline
      filtered = positions.filter do |p|
        p.match?(conditions)
      end
      Exfuz::Candidates.new(filtered)
    end

    def group_by(keys)
      pipeline
      Exfuz::Group.new(positions, keys)
    end

    def each_by_filter(word = '', attr: :value)
      regexp = Regexp.new(word)
      @items.each do |k, v|
        if word.empty?
          yield k, v
        # 文字列型以外の値もあるので一旦Stringに変換する
        elsif v.method(attr).call.to_s =~ regexp
          yield k, v
        end
      end
    end

    private
    def pipeline
      while data = @@queue.pop
        @processed << data
      end
      @@queue.close
    end
  end
end
