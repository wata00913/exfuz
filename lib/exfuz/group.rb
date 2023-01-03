# frozen_string_literal: true

module Exfuz
  class Group
    def initialize(positions, keys)
      @data = {}
      @raw_positions = positions
      create(positions, keys)
    end

    def create(positions, keys)
      indices = (0...positions.size).to_a
      keys.each do |key|
        @data[key] = indices.group_by { |idx| positions[idx].slice(key) }
                            .values
      end
    end

    def key_positions(key)
      @data[key].map do |grouping_indices|
        @raw_positions[grouping_indices.first].slice(key)
      end
    end

    def positions(key)
      @data[key].each_with_object({}) do |grouping_indices, result|
        key_position = @raw_positions[grouping_indices.first].slice(key)
        result[key_position] = grouping_indices.map do |grouping_idx|
          @raw_positions[grouping_idx]
        end
      end
    end
  end
end
