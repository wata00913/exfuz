# frozen_string_literal: true

require 'curses'
require 'timeout'
require_relative 'parser'
require_relative 'candidate'
require_relative 'cell'

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
      c = Exfuz::Cell.new(address: cell[:cell], value: cell[:value])
      data << Exfuz::Candidate.new(book_name: cell[:book_name],
                                   sheet_name: cell[:sheet_name],
                                   textable: c)
    end

    $num_finished_loading_file = idx + 1
  end
end

def candidate_by(candidates, line, sep: ':')
  lnum = line.split(sep)[0]
  candidates[lnum.to_i - 1]
end

def start_fuzzy_finder(candidates)
  cmds = %w[fzf]

  begin
    stdio = IO.popen(cmds, 'r+')
    candidates.each_with_index do |c, idx|
      stdio.puts "#{idx + 1}:#{c.to_s}"
    end
  ensure
    stdio.close_write
    selected = stdio.read.chomp
    stdio.close_read
  end
  selected
end

def main
  xlsxs = Dir.glob('**/*.xlsx')
  init_display($num_finished_loading_file, xlsxs.size)
  Curses.close_screen
  init_display(0, xlsxs.size)

  data = []
  Thread.new do
    sleep 0.01
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
      Timeout.timeout(0.1) do
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
      line = start_fuzzy_finder(data)
      selected = candidate_by(data, line)
      Curses.clear
      init_display($num_finished_loading_file, xlsxs.size)
    end
  end
end

main
