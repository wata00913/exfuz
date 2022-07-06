# frozen_string_literal: true

require_relative "exfuz/version"

module Exfuz
  class Error < StandardError; end
  autoload :Parser, 'exfuz/parser'
end
