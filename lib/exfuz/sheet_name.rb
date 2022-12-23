# frozen_string_literal: true

module Exfuz
  class SheetName
    attr_reader :name

    include Exfuz::Util

    def initialize(name)
      @name = @text = name
    end

    def ==(other)
      return false if other.nil? || !other.instance_of?(Exfuz::SheetName)

      name == other.name
    end
  end
end
