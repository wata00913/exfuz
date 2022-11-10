# frozen_string_literal: true

require_relative 'exfuz/version'

module Exfuz
  class Error < StandardError; end
  autoload :Parser, 'exfuz/parser'
  autoload :Candidate, 'exfuz/candidate'
  autoload :Cell, 'exfuz/cell'
  autoload :Query, 'exfuz/query'
end
