# frozen_string_literal: true

module Exfuz
  class FuzzyFinderCommand
    attr_reader :selected

    def initialize(candidates)
      @candidates = candidates
      @selected = ''
    end

    def run
      cmds = %w[fzf]

      begin
        stdio = IO.popen(cmds, 'r+')
        @candidates.each_with_index do |c, idx|
          stdio.puts "#{idx + 1}:#{c}"
        end
      ensure
        stdio.close_write
        @selected = stdio.read.chomp
        stdio.close_read
      end
    end
  end
end
