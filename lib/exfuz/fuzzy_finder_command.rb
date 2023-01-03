# frozen_string_literal: true

module Exfuz
  class FuzzyFinderCommand
    attr_reader :selected

    def initialize
      @selected = ''
    end

    def run
      cmds = %w[fzf -m]

      begin
        stdio = IO.popen(cmds, 'r+')
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
        @selected = stdio.read.chomp
        stdio.close_read
      end
    end

    private

    def puts_line(stdio, line)
      stdio.puts line
    end
  end
end
