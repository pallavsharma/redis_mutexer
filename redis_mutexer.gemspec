# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_mutexer/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_mutexer"
  spec.version       = RedisMutexer::VERSION
  spec.authors       = ["IAmPallavSharma"]
  spec.email         = ["mail.pallavsharma@gmail.com"]

  spec.summary       = %q{Locking object for a user, using redis.}
  spec.description   = %q{Locking object for a user for a given time, using redis. Preventing other users to edit it at the same time.}
  spec.homepage      = "https://github.com/pallavsharma/redis_mutexer"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "sqlite3", ">= 1.3.13"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "activerecord", ">= 4.0.0"

  # Dependencies
  spec.add_runtime_dependency "redis", "~> 3.0.7"

end
