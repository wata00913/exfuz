# frozen_string_literal: true

module Exfuz
  class Position
    def initialize(hierarchy)
      @key_to_obj = {}
      @hierarchy = hierarchy
      hierarchy.each do |h|
        k = h.keys[0]
        @key_to_obj[k] = h[k]

        instance_eval "@#{k} = h[k]", __FILE__, __LINE__
        self.class.send(:attr_reader, k)
      end
    end

    def bottom_name
      @key_to_obj.keys.last
    end

    def slice(key)
      keys = @key_to_obj.keys
      remaining = keys[0, (keys.find_index { |k| k == key }) + 1]
      args = @hierarchy.filter do |h|
        remaining.include?(h.keys[0])
      end
      Exfuz::Position.new(args)
    end

    def slice_keys(key)
      keys = @key_to_obj.keys
      keys[0, (keys.find_index { |k| k == key }) + 1]
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

    def jump_info
      keys = @key_to_obj.keys
      keys.each_with_object({}) do |key, result|
        obj = send(key)
        result.merge!(obj.jump_info)
      end
    end

    def ==(other)
      other.class === self && other.hash == hash
    end
    alias eql? ==

    def hash
      @key_to_obj.values.hash
    end
  end
end
