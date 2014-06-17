# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minions/version'

Gem::Specification.new do |spec|
  spec.name          = "minions"
  spec.version       = Minions::VERSION
  spec.authors       = ["Ronnie Howell"]
  spec.email         = ["ronnie@rhowell.me"]
  spec.summary       = %q{My take on Actors in Ruby}
  spec.description   = %q{You can't take over the world without minions.  Make them do your bidding with little regard for their own safety or wellbeing.}
  spec.homepage      = "https://github.com/rhowell/minions"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "byebug"
end
