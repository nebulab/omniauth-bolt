# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'omniauth-bolt/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-bolt'
  s.version     = OmniAuth::Bolt::VERSION
  s.authors     = ['Daniele Palombo']
  s.email       = ['danielepalombo@nebulab.com']
  s.homepage    = 'https://github.com/nebulab/omniauth-bolt'
  s.description = 'OmniAuth strategy for Bolt'
  s.summary     = s.description
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.required_ruby_version = Gem::Requirement.new('>= 1.9.3')
  s.add_dependency 'omniauth-oauth', '~> 1.1'
  s.add_dependency 'rack'
  s.add_development_dependency 'bundler', '~> 1.0'
end
