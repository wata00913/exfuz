# frozen_string_literal: true

require 'curses'

module Exfuz
  class Screen
    attr_reader :query

    def initialize(status = nil, caret = nil, key_map = nil)
      @status = status
      @prev_loaded = @status.loaded
      @key_map = key_map
      @query = Exfuz::Query.new(caret || [0, 0])
    end

    def status
      @status.to_s
    end

    def init
      Curses.init_screen
      # キー入力の文字を画面に反映させない
      Curses.noecho
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
      when Exfuz::Key::CTRL_E
        close
      when Exfuz::Key::CTRL_R
        Curses.clear
        init
      when Exfuz::Key::BACKSPACE
        @query.delete
        refresh
      when Exfuz::Key::LEFT
        @query.left
        refresh
      when Exfuz::Key::RIGHT
        @query.right
        refresh
      when 27
        mch = Exfuz::Key.to_key([ch, Curses.getch.bytes, Curses.getch.bytes].flatten)
        case mch
        when Exfuz::Key::LEFT
          @query.left
        when Exfuz::Key::RIGHT
          @query.right
        end
        refresh
      else
        # 印字可能でない文字の場合
        if ch.instance_of?(Integer)
          mbytes = [ch]
          # スレッドセーフでないかも
          # 稀に正常にchが読み込めない場合があった
          loop do
            remaining = Curses.getch
            break if remaining.nil?

            mbytes << remaining
          end
          @query.add(mbytes)
        else
          @query.add(ch)
        end
        refresh
      end
    end

    def draw
      print_head_line

      reset_caret
    end

    def reset_caret
      Curses.setpos(*@query.caret)
    end

    def print_head_line
      # 前回の入力内容を保持してないためクエリの全文字を再描画
      Curses.setpos(0, 0)
      Curses.addstr(@query.line)

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
