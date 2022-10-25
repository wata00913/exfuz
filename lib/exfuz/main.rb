# frozen_string_literal: true

require 'curses'
require 'timeout'
require_relative 'parser'
require_relative 'candidate'
require_relative 'cell'
require_relative 'screen'
require_relative 'status'

def read_data(xlsxs, data = [], status)
  xlsxs.each_with_index do |xlsx, _idx|
    p = Exfuz::Parser.new(xlsx)
    p.parse
    p.each_cell_with_all do |cell|
      c = Exfuz::Cell.new(address: cell[:cell], value: cell[:value])
      data << Exfuz::Candidate.new(book_name: cell[:book_name],
                                   sheet_name: cell[:sheet_name],
                                   textable: c)
    end

    status.update(1)
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
      stdio.puts "#{idx + 1}:#{c}"
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

  status = Exfuz::Status.new(xlsxs.size)
  caret = [0, 0]
  screen = Exfuz::Screen.new(status, caret)

  screen.init
  Curses.close_screen
  screen.init

  data = []
  Thread.new do
    sleep 0.01
    read_data(xlsxs, data, status)
  end

  loop do
    unless Thread.list.find { |t| t.name == 'wating_for_input' }
      in_t = Thread.new do
        screen.rerender if screen.changed_state?
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
      screen.init
    end
  end
end

main
