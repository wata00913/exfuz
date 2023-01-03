# frozen_string_literal: true

require 'json'

module Exfuz
  class Jump
    OPERATOR_PATH = './operator.ps1'
    OPERATOR_CMD = "PowerShell.exe '$Input | #{OPERATOR_PATH}'"

    def initialize(positions)
      @positions = positions
    end

    def run
      data = @positions.map do |p|
        { to: p.bottom_name, info: p.jump_info }
      end

      result = nil
      IO.popen(OPERATOR_CMD, 'r+') do |io|
        io.puts JSON.unparse(data)
        io.close
        result = io.read
      end
      result
    end
  end
end
