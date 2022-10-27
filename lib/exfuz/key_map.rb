# frozen_string_literal: true

require 'curses'

module Exfuz
  class KeyMap
    def initialize
      @kmap = {}
    end

    def add_event_handler(key, obj, func: :update)
      @kmap[key] ||= Exfuz::Event.new
      @kmap[key].add_event_handler(obj, func)
    end

    def pressed(key)
      return unless @kmap.key?(key)

      @kmap[key].fired
    end
  end
end
