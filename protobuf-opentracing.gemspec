
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "protobuf/opentracing/version"

Gem::Specification.new do |spec|
  spec.name          = "protobuf-opentracing"
  spec.version       = Protobuf::Opentracing::VERSION
  spec.authors       = ["Marcos Minond"]
  spec.email         = ["minond.marcos@gmail.com"]

  spec.summary       = "Add service to service tracing with Opentracing."
  spec.description   = "Add service to service tracing with Opentracing."
  spec.homepage      = "https://github.com/mxenabled/protobuf-opentracing"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Hack, as Rails 5 requires Ruby version >= 2.2.2.
  active_support_max_version = "< 5" if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.2.2")
  spec.add_dependency "activesupport", ">= 3.2", active_support_max_version
  spec.add_dependency "opentracing"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "jaeger-client"
  spec.add_development_dependency "mad_rubocop"
  spec.add_development_dependency "opentracing_test_tracer"
  spec.add_development_dependency "protobuf", "~> 3.10.0"
  spec.add_development_dependency "protobuf-nats"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
