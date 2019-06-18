# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image_trans_test_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "image_trans_test_generator"
  spec.version       = ImageTransTestGenerator::VERSION
  spec.authors       = ["Tomokazu Kiyohara"]
  spec.email         = ["tomokazu.kiyohara@gmail.com"]

  spec.summary       = %q{Image URI listup tool for HTTP transport quality test.}
  spec.description   = %q{Image URI listup tool for HTTP transport quality test.}
  spec.homepage      = "https://github.com/kiyohara/image_trans_test_generator"

  # # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "thor"
  spec.add_dependency "nokogiri"
  spec.add_dependency "ltsv"
  spec.add_dependency "hashie"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "faraday-cookie_jar"
  spec.add_dependency "faraday-encoding"
end
