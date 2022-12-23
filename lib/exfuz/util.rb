# frozen_string_literal: true

module Exfuz
  module Util
    def match?(word)
      regexp = Regexp.new(word.downcase, Regexp::IGNORECASE)
      @text.match?(regexp)
    end
  end
end
