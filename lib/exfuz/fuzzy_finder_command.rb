# frozen_string_literal: true

module Exfuz
  class FuzzyFinderCommand
    attr_reader :selected

    CMDS = { fzf: %w[fzf -m], peco: 'peco', percol: 'percol', sk: %w[sk -m] }.freeze

    def initialize(command_type: :fzf)
      @selected = ''
      @cmd = CMDS[command_type] || CMDS[:fzf]
    end

    def run
      stdio = IO.popen(@cmd, 'r+')
      fiber = Fiber.new do |init_line|
        puts_line(stdio, init_line)
        loop do
          line = Fiber.yield
          puts_line(stdio, line)
        end
      end

      yield fiber
    ensure
      stdio.close_write
      @selected = stdio.each_line(chomp: true).to_a
      stdio.close_read
    end

    private

    def puts_line(stdio, line)
      stdio.puts line
    end
  end
end
