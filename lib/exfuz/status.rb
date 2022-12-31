# frozen_string_literal: true

module Exfuz
  class Status
    attr_reader :loaded, :max

    def initialize(max)
      @loaded = 0
      @max = max
    end

    def update(num)
      @loaded += num
    end

    def finished?
      @loaded == @max
    end

    # TODO: メソッド名を変更すること
    def to_s
      "[#{@loaded}/#{@max}]"
    end
  end
end
