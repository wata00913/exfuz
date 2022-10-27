# frozen_string_literal: true

require 'observer'

module Exfuz
  class Event
    include Observable
    def add_event_handler(obj, func)
      add_observer(obj, func)
    end

    def fired
      changed
      notify_observers
    end
  end
end
