# frozen_string_literal: true

require_relative 'exfuz/version'

module Exfuz
  class Error < StandardError; end
  autoload :BookName, 'exfuz/book_name'
  autoload :Candidate, 'exfuz/candidate'
  autoload :Candidates, 'exfuz/candidates'
  autoload :Cell, 'exfuz/cell'
  autoload :Configuration, 'exfuz/configuration'
  autoload :Command, 'exfuz/command'
  autoload :Event, 'exfuz/event'
  autoload :FuzzyFinderCommand, 'exfuz/fuzzy_finder_command'
  autoload :KeyMap, 'exfuz/key_map'
  autoload :Parser, 'exfuz/parser'
  autoload :Query, 'exfuz/query'
  autoload :Screen, 'exfuz/screen'
  autoload :Status, 'exfuz/status'
end
