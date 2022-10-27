# frozen_string_literal: true

require 'curses'

module Exfuz
  class Screen
    def initialize(status = nil, caret = nil, key_map = nil)
      @caret = caret || [0, 0]
      @status = status
      @prev_loaded = @status.loaded
      @key_map = key_map
    end

    def status
      @status.to_s
    end

    def init
      Curses.init_screen
      # 入力の待機時間(milliseconds)
      Curses.timeout = 100
      draw
      Curses.refresh
    end

    def rerender
      @prev_loaded = @status.loaded
      refresh
    end

    def refresh
      draw
      Curses.refresh
    end

    def wait_input
      @ch = Curses.getch
      # 待機時間内に入力されない場合
      return unless @ch

      # イベント内の処理で描画する場合があるためキャレットの更新を先に行う
      @caret[1] += 1
      handle_event(@ch)
    end

    # 表示内容の変更検知を判定する
    def changed_state?
      @prev_loaded < @status.loaded
    end

    def closed?
      Curses.closed?
    end

    def close
      Curses.close_screen
    end

    private

    def handle_event(ch)
      @key_map.pressed(ch)
      case ch
      when 'q'
        close
      when 'f'
        Curses.clear
        init
      end
    end

    def draw
      print_head_line

      reset_caret
    end

    def reset_caret
      Curses.setpos(*@caret)
    end

    def print_head_line
      col = Curses.cols - status.size
      Curses.setpos(0, col)
      Curses.addstr(status)
    end
  end
end

def main
  require_relative './status'
  screen = Exfuz::Screen.new(Exfuz::Status.new(10))
  screen.init
  until screen.closed?
    # キー入力を待機
    screen.handle_input
  end
  screen.close
end

main if __FILE__ == $0
