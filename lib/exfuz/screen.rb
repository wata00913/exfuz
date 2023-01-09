# frozen_string_literal: true

require 'curses'

module Exfuz
  class Screen
    attr_reader :query

    def initialize(status = nil, key_map = nil, candidates = nil)
      @status = status
      @prev_loaded = @status.loaded
      @key_map = key_map
      @prompt = '>'
      @query = Exfuz::Query.new([0, @prompt.size])
      @cmd = Exfuz::FuzzyFinderCommand.new
      @candidates = candidates
      @conf = Exfuz::Configuration.instance

      @description = Exfuz::Body.new(top: 1, bottom: 1, texts: ['please input query'])
      @list = Exfuz::Body.new(top: 2)

      register_event
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

    # event
    def start_cmd
      filtered = @candidates.filter({ textable: @query.text })
      @cmd.run do |fiber|
        filtered.positions.each_with_index do |position, idx|
          value_text = position.textable.value.to_s
          line = [
            idx,
            position.book_name.relative_path,
            position.sheet_name.name,
            position.textable.position_s(format: @conf.cell_position_format),
            @conf.split_new_line ? value_text : value_text.gsub(/\R+/) { '\n' }
          ].join(@conf.line_sep)
          fiber.resume(line)
        end
      end

      selected_positions = @cmd.selected.map do |s|
        idx = s.split(@conf.line_sep).first.to_i
        filtered.positions[idx]
      end

      if Exfuz::Util.wsl?
        jump = Exfuz::Jump.new(selected_positions)
        jump.run
      end

      texts = @cmd.selected.enum_for.with_index(0).each_with_object({}) do |(s, line_num), result|
        result[line_num] = s
      end
      @list.change_all(texts)

      Curses.clear
      init
    end

    def delete_char
      @query.delete
      refresh
    end

    def move_left
      @query.left
      refresh
    end

    def move_right
      @query.right
      refresh
    end

    def finish
      close
    end

    def insert_char(char)
      @query.add(char)
      refresh
    end

    private

    def handle_event(ch)
      input = if Exfuz::Key.can_convert_to_name_and_char?(ch)
                ch
              else
                chs = [ch]
                # スレッドセーフでないかも
                # 稀に正常にchが読み込めない場合があった
                loop do
                  remaining = Curses.getch
                  break if remaining.nil?

                  chs << remaining
                end
                chs
              end

      name, char = Exfuz::Key.input_to_name_and_char(input)

      char.nil? ? @key_map.pressed(name) : @key_map.pressed(name, char)
    end

    def register_event
      @key_map.add_event_handler(Exfuz::Key::CTRL_R, self, func: :start_cmd)
      @key_map.add_event_handler(Exfuz::Key::CTRL_E, self, func: :finish)
      @key_map.add_event_handler(Exfuz::Key::LEFT, self, func: :move_left)
      @key_map.add_event_handler(Exfuz::Key::RIGHT, self, func: :move_right)
      @key_map.add_event_handler(Exfuz::Key::BACKSPACE, self, func: :delete_char)
      @key_map.add_event_handler(Exfuz::Key::CHAR, self, func: :insert_char)
    end

    def draw
      print_head_line

      print_description

      print_body

      reset_caret
    end

    def reset_caret
      Curses.setpos(*@query.caret)
    end

    def print_head_line
      # 前回の入力内容を保持してないためクエリの全文字を再描画
      Curses.setpos(0, 0)
      Curses.addstr(@prompt + @query.line)

      col = Curses.cols - status.size
      Curses.setpos(0, col)
      Curses.addstr(status)
    end

    def print_description
      @description.lines.each do |row, line|
        print_line(row: row, line: line)
      end
    end

    def print_body
      @list.lines(overwrite: true).each do |row, line|
        print_line(row: row, line: line)
      end
    end

    def print_line(row:, line:)
      Curses.setpos(row, 0)
      Curses.addstr(line)
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
