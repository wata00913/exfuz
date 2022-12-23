# frozen_string_literal: true

module Exfuz
  class Position
    def initialize(hierarchy)
      @key_to_obj = {}
      @hierarchy = []
      hierarchy.each do |h|
        k = h.keys[0]
        @key_to_obj[k] = h[k]
        @hierarchy << k
      end
    end

    def match?(conditions)
      conditions.each do |key, value|
        unless obj = @key_to_obj[key]
          raise 'not exist key'
        end

        return false unless obj.match?(value)
      end
      true
    end
  end
end
