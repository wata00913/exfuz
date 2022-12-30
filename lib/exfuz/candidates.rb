# frozen_string_literal: true

module Exfuz
  class Candidates
    @@queue = Queue.new
    @@raw = []

    def initialize(items = [])
      @processed = items
    end

    def push(item)
      @@queue << item
    end

    def suspend_push
      @@queue << nil
    end

    def close_push?
      @@queue.closed?
    end

    def close_push
      @@queue << nil
      @@queue.close
    end

    def positions
      @processed.empty? ? @@raw : @processed
    end

    def filter(conditions)
      pipeline
      filtered = positions.filter do |position|
        position.match?(conditions)
      end
      Exfuz::Candidates.new(filtered)
    end

    def group_by(keys)
      pipeline
      Exfuz::Group.new(positions, keys)
    end

    private
    def pipeline
      while data = @@queue.pop
        @processed << data
      end
    end
  end
end
