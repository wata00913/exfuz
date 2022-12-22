# frozen_string_literal: true

module Exfuz
  class SheetName
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def ==(other)
      return false if other.nil? || !other.instance_of?(Exfuz::SheetName)

      name == other.name
    end
  end
end
