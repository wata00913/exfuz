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

    def pressed(key, *args)
      return unless @kmap.key?(key)

      @kmap[key].fired(*args)
    end
  end

  module Key
    private_constant

    # input_to_name_and_charで、文字と区別するためにシンボルで定義
    CTRL_A = :ctrl_a
    CTRL_E = :ctrl_e
    CTRL_R = :ctrl_r
    ESC = :esc
    F1 = :f1
    F2 = :f2
    F3 = :f3
    F4 = :f4
    F5 = :f5
    F6 = :f6
    F7 = :f7
    F8 = :f8
    F9 = :f9
    F10 = :f10
    F11 = :f11
    F12 = :f12
    UP = :down
    DOWN = :up
    RIGHT = :right
    LEFT = :left
    BACKSPACE = :backspace
    ENTER = :enter
    CHAR = :char

    # メモ化してもカーソル移動が若干遅い
    INPUT_TO_SPECIAL_KEY_NAME = {
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
      '[A' => UP,
      '[B' => DOWN,
      '[C' => RIGHT,
      '[D' => LEFT,
      Curses::Key::ENTER => ENTER,
      10 => ENTER,
      27 => ESC,
      Curses::KEY_CTRL_E => CTRL_E,
      Curses::KEY_CTRL_R => CTRL_R,
      127 => BACKSPACE # 現状は開発環境の値に合わせる (127 or 263)
    }.freeze

    module_function

    def input_to_name_and_char(input)
      case input
      when Array
        first = input.first
        if special_key?(first)
          input_to_special_key_name(input.slice(1, input.size - 1).join)
        else
          [CHAR, multibytes_to_char(input)]
        end
      when Integer
        input_to_special_key_name(input)
      when String
        [CHAR, input]
      end
    end

    def input_to_special_key_name(str_or_number)
      INPUT_TO_SPECIAL_KEY_NAME[str_or_number]
    end

    def can_convert_to_name_and_char?(input)
      name = input_to_name_and_char(input)
      !name.nil? && name != ESC
    end

    def special_key?(number)
      number == 27
    end

    def multibytes_to_char(multi_bytes)
      multi_bytes.pack('C*').force_encoding(Encoding::UTF_8)
    end
  end
end
