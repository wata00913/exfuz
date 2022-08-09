# frozen_string_literal: true

require 'curses'
require 'timeout'
require_relative 'parser'

$num_finished_loading_file = 0

def init_display(finished, max)
  Curses.init_screen
  status = "[#{finished}/#{max}]"
  col = Curses.cols - status.length
  Curses.setpos(0, col)
  Curses.addstr(status)
  Curses.setpos(0, 0)
  Curses.refresh
end

def my_refresh(finished, max, caret)
  status = "[#{finished}/#{max}]"
  col = Curses.cols - status.length
  Curses.setpos(0, col)
  Curses.addstr(status)
  Curses.setpos(0, caret[1])
  Curses.refresh
end

def read_data(xlsxs, data = [])
  xlsxs.each_with_index do |xlsx, idx|
    p = Exfuz::Parser.new(xlsx)
    p.parse
    p.each_cell_with_all do |cell|
      data << cell
    end
    $num_finished_loading_file = idx + 1
  end
end

def start_fuzzy_finder(candidates)
  cmds = %w[fzf]

  stdio = IO.popen(cmds, 'r+')
  stdio.puts candidates.pop until candidates.empty?
  stdio.close_write

  selected = stdio.read
  stdio.close_read
  selected
end

def main
  xlsxs = Dir.glob('**/*.xlsx')
  init_display($num_finished_loading_file, xlsxs.size)
  Curses.close_screen
  init_display(0, xlsxs.size)

  data = []
  #read_data(xlsxs, data)
  Thread.new do
    read_data(xlsxs, data)
  end

  # 入力
  caret = [0, 0]
  last = $num_finished_loading_file
  loop do
    unless Thread.list.find { |t| t.name == 'wating_for_input' }
      in_t = Thread.new do
        if last < $num_finished_loading_file
          last = $num_finished_loading_file
          my_refresh($num_finished_loading_file, xlsxs.size, caret)
        end
      end
      in_t.name = 'wating_for_input'
    end

    ch = ''
    begin
      Timeout.timeout(0.01) do
        ch = Curses.getch
      end
      caret[1] += 1
    rescue TimeoutError
      ch = ''
    end

    case ch
    when 'q'
      break
    when 'f'
      selected = start_fuzzy_finder(data)
      # 別プロセスでTUIを起動すると端末が初期化されない。
      # Curses.close_screenで端末の状態を復帰させ、始めから描画させる必要がある
      Curses.close_screen
      init_display($num_finished_loading_file, xlsxs.size)
    end
  end
end

main
