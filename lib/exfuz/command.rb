require 'thor'
require_relative 'main'

module Exfuz
  class Command < Thor
    desc "start", "start exfuz"
    def start
      main
    end
  end
end
