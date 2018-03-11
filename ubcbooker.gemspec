lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ubcbooker/version"

Gem::Specification.new do |spec|
  spec.name          = "ubcbooker"
  spec.version       = Ubcbooker::VERSION
  spec.authors       = ["Atsushi Yamamoto"]
  spec.email         = ["hi@atsushi.me"]

  spec.summary       = "CLI tool to book project rooms in UBC"
  spec.description   = "CLI tool to book project rooms in UBC"
  spec.homepage      = "https://github.com/jumbosushi/ubcbooker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = ["ubcbooker"]
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize", "~> 2.7"
  spec.add_dependency "business_time", "~> 0.9.3"
  spec.add_dependency "typhoeus", "~> 1.1"
  spec.add_dependency "obscenity", "~> 1.0.2"
  spec.add_dependency "tty-spinner", "~> 0.7.0"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.11.3"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "rubocop-github", "~> 0.8.1"
end
