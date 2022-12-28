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

  module Key
    RIGHT = Curses::Key::RIGHT
    LEFT = Curses::Key::LEFT
    ENTER = 'enter'
    CTRL_A = 'ctrl-a'
    CTRL_E = Curses::KEY_CTRL_E
    CTRL_R = Curses::KEY_CTRL_R
    ESC = 'esc'
    F1 = 'f1'
    F2 = 'f2'
    F3 = 'f3'
    F4 = 'f4'
    F5 = 'f5'
    F6 = 'f6'
    F7 = 'f7'
    F8 = 'f8'
    F9 = 'f9'
    F10 = 'f10'
    F11 = 'f11'
    F12 = 'f12'
    # 現状は開発環境の値に合わせる (127 or 263)
    BACKSPACE = 127

    module_function

    def input_to_name_or_char(input)
      case input
      when Array
        first = input.first
        if special_key?(first)
          input_to_special_key_name(input.slice(1, input.size - 1).join)
        else
          multibytes_to_char(input)
        end
      when Integer
        input_to_special_key_name(input)
      when String
        input
      end
    end

    def to_key(bytes)
      {
        185 => RIGHT,
        186 => LEFT
      }[bytes.sum]
    end

    def input_to_special_key_name(str_or_number)
      {
        'OP' => F1,
        'OQ' => F2,
        'OR' => F3,
        'OS' => F4,
        '[15' => F5,
        '[17' => F6,
        '[18' => F7,
        '[19' => F8,
        '[20' => F9,
        '[21' => F10,
        '[23' => F11,
        '[24' => F12,
        Curses::Key::ENTER => 'enter',
        10 => 'enter',
        27 => 'esc'
      }[str_or_number]
    end

    def special_key?(number)
      number == 27
    end

    def multibytes_to_char(multi_bytes)
      multi_bytes.pack('C*').force_encoding(Encoding::UTF_8)
    end
  end
end
