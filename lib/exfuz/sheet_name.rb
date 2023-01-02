# frozen_string_literal: true

module Exfuz
  class SheetName
    def self.name
      :sheet_name
    end

    attr_reader :name

    include Exfuz::Util

    def initialize(name)
      @name = @text = name
    end

    def ==(other)
      return false if other.nil? || !other.instance_of?(Exfuz::SheetName)

      name == other.name
    end

    def hash
      @name.hash
    end

    def jump_info
      { Exfuz::SheetName.name => @name }
    end
  end
end
