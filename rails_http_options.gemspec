# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_http_options/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_http_options"
  spec.version       = RailsHttpOptions::VERSION
  spec.authors       = ["Filippos Vasilakis", "Kollegorna"]
  spec.email         = ["vasilakisfil@gmail.com"]

  spec.summary       = %q{Simple gem that makes it easy to handle HTTP OPTIONS requests in Rails.}
  spec.description   = %q{Simple gem that makes it easy to handle HTTP OPTIONS requests in Rails.}
  spec.homepage      = "https://github.com/kollegorna/rails_http_options"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "Rails", "> 3.2.0"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
