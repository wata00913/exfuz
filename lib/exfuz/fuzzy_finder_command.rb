# frozen_string_literal: true

module Exfuz
  class FuzzyFinderCommand
    attr_reader :selected

    def initialize(candidates, query)
      @candidates = candidates
      @selected = ''
      @query = query
    end

    def run
      cmds = %w[fzf]

      begin
        stdio = IO.popen(cmds, 'r+')
        @candidates.each_by_filter(@query.text) do |idx, c|
          stdio.puts "#{idx}:#{c.to_line}"
        end
      ensure
        stdio.close_write
        @selected = stdio.read.chomp
        stdio.close_read
      end
    end
  end
end
