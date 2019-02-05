
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
  spec.homepage      = "https://gitlab.mx.com/mx/protobuf-opentracing-middleware"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://gems.internal.mx"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

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

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "mad_rubocop"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
