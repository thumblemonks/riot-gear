# -*- encoding: utf-8 -*-
$:.unshift(File.expand_path("../lib", __FILE__))
require "riot/gear/version"

Gem::Specification.new do |s|
  s.name          = %q{riot-gear}
  s.version       = Riot::Gear::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Justin 'Gus' Knowlden"]
  s.summary       = %q{Riot + HTTParty smoke testing framework.}
  s.description   = %q{Riot + HTTParty smoke testing framework. You'd use it for integration testing with real HTTP requests and responses}
  s.email         = %q{gus@gusg.us}
  s.files         = `git ls-files`.split("\n") 
  s.homepage      = %q{http://github.com/thumblemonks/riot-gear}
  s.require_paths = ["lib"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency 'riot', '>=0.12.5'
  s.add_dependency 'crack', '>=0.1.7'
  s.add_dependency 'httparty', '>=0.6.0'
  s.add_dependency 'webmock', '>=1.6.1'
end

