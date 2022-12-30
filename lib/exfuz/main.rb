# frozen_string_literal: true

def read_data(xlsxs, candidates = [], status)
  xlsxs.each_with_index do |xlsx, _idx|
    p = Exfuz::Parser.new(xlsx)
    p.parse
    p.each_cell_with_all do |cell|
      b = Exfuz::BookName.new(cell[:book_name])
      s = Exfuz::SheetName.new(cell[:sheet_name])
      c = Exfuz::Cell.new(address: cell[:cell], value: cell[:value])
      candidates.push(Exfuz::Position.new([{ book_name: b }, { sheet_name: s }, { textable: c }]))
    end

    status.update(1)
  end
  candidates.close_push
end

def candidate_by(candidates, line, sep: ':')
  lnum = line.split(sep)[0]
  candidates[lnum.to_i - 1]
end

def main
  xlsxs = Dir.glob('**/[^~$]*.xlsx')

  status = Exfuz::Status.new(xlsxs.size)
  candidates = Exfuz::Candidates.new
  key_map = Exfuz::KeyMap.new
  caret = [0, 0]
  screen = Exfuz::Screen.new(status, caret, key_map, candidates)

  screen.init
  Curses.close_screen
  screen.init

  Thread.new do
    sleep 0.01
    read_data(xlsxs, candidates, status)
  end

  loop do
    unless Thread.list.find { |t| t.name == 'wating_for_input' }
      in_t = Thread.new do
        screen.rerender if screen.changed_state?
      end
      in_t.name = 'wating_for_input'
    end

    screen.wait_input
    break if screen.closed?
  end
end

if $PROGRAM_NAME == __FILE__
  $LOAD_PATH.unshift(File.expand_path('..', __dir__))
  require_relative '../exfuz'
  main
end
