# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'genesis/version'

Gem::Specification.new do |spec|
  spec.name          = 'genesis_cli'
  spec.version       = Genesis::VERSION
  spec.authors       = ['Tyler Cross']
  spec.email         = ['tcross@bandwidth.com']
  spec.description   = %q(A terraform wrapper for Bandwidth Incubator)
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/bandwidthcom/genesis'
  spec.licenses      = %w[MIT]

  spec.executables   = %w[genesis]

  spec.files         = %w[LICENSE.txt README.md Thorfile genesis.gemspec]
  spec.files        += Dir.glob('bin/**/*')
  spec.files        += Dir.glob('lib/**/*.rb')
  spec.files        += Dir.glob('spec/**/*')

  spec.test_files    = Dir.glob('spec/**/*')

  spec.require_paths = %w[lib]
  
  spec.add_dependency 'thor'

  spec.add_development_dependency 'bundler', '~> 1.6'
end
