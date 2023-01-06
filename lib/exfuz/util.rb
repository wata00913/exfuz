# frozen_string_literal: true

require 'etc'

module Exfuz
  module Util
    def match?(word)
      regexp = Regexp.new(word.downcase, Regexp::IGNORECASE)
      @text.match?(regexp)
    end

    module_function

    def wsl?
      Etc.uname[:release].match?(/.*microsoft.*/)
    end

    def wsl_to_windows(path)
      nil unless wsl?

      raise ArgumentError, 'not exists path' unless File.exist?(path)

      `wslpath -w #{path}`.chomp
    end
  end
end
