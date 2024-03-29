# frozen_string_literal: true

require_relative 'exfuz/version'

module Exfuz
  class Error < StandardError; end
  autoload :BookName, 'exfuz/book_name'
  autoload :Body, 'exfuz/body'
  autoload :Candidate, 'exfuz/candidate'
  autoload :Candidates, 'exfuz/candidates'
  autoload :Cell, 'exfuz/cell'
  autoload :Configuration, 'exfuz/configuration'
  autoload :Command, 'exfuz/command'
  autoload :Event, 'exfuz/event'
  autoload :FuzzyFinderCommand, 'exfuz/fuzzy_finder_command'
  autoload :Group, 'exfuz/group'
  autoload :Jump, 'exfuz/jump'
  autoload :Key, 'exfuz/key_map'
  autoload :KeyMap, 'exfuz/key_map'
  autoload :Parser, 'exfuz/parser'
  autoload :Position, 'exfuz/position'
  autoload :Query, 'exfuz/query'
  autoload :Screen, 'exfuz/screen'
  autoload :SheetName, 'exfuz/sheet_name'
  autoload :Status, 'exfuz/status'
  autoload :Util, 'exfuz/util'
end
