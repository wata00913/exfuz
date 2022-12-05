# frozen_string_literal: true

def read_data(xlsxs, candidates = [], status)
  xlsxs.each_with_index do |xlsx, _idx|
    p = Exfuz::Parser.new(xlsx)
    p.parse
    p.each_cell_with_all do |cell|
      c = Exfuz::Cell.new(address: cell[:cell], value: cell[:value])
      candidates.push(Exfuz::Candidate.new(book_name: cell[:book_name],
                                           sheet_name: cell[:sheet_name],
                                           textable: c))
    end

    status.update(1)
  end
end

def candidate_by(candidates, line, sep: ':')
  lnum = line.split(sep)[0]
  candidates[lnum.to_i - 1]
end

def main
  xlsxs = Dir.glob('**/*.xlsx')

  status = Exfuz::Status.new(xlsxs.size)
  candidates = Exfuz::Candidates.new
  key_map = Exfuz::KeyMap.new
  caret = [0, 0]
  screen = Exfuz::Screen.new(status, caret, key_map)
  cmd = Exfuz::FuzzyFinderCommand.new(candidates, screen.query)
  key_map.add_event_handler(Exfuz::Key::CTRL_R, cmd, func: :run)

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
