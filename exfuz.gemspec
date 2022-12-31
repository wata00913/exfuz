# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('./lib', __FILE__))
require_relative "lib/exfuz/version"

Gem::Specification.new do |spec|
  spec.name          = "exfuz"
  spec.version       = Exfuz::VERSION
  spec.authors       = ["wata00913"]
  spec.email         = ["175d8639@gmail.com"]

  spec.summary       = "excel fuzzy finder"
  spec.description   = "Fuzzy finder excel. This uses a fuzzy finder such as peco or fzf."
  spec.homepage      = "https://github.com/wata00913/exfuz"
  spec.required_ruby_version = ">= 2.4.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = ["exfuz"]
  spec.require_paths = ["lib"]

end
