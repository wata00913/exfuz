# frozen_string_literal: true

require 'pathname'

module Exfuz
  class BookName
    def self.name
      :book_name
    end

    attr_reader :absolute_path

    include Exfuz::Util

    def initialize(file_name)
      @absolute_path = @text = File.absolute_path(file_name)
    end

    def ==(other)
      absolute_path == other.absolute_path
    end

    def hash
      absolute_path.hash
    end

    def relative_path
      Pathname.new(@absolute_path).relative_path_from(Dir.pwd).to_s
    end

    def jump_info
      path = wsl? ? wsl_to_windows(@absolute_path) : @absolute_path
      { Exfuz::BookName.name => path }
    end
  end
end
