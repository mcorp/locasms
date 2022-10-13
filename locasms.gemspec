# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locasms/version'

Gem::Specification.new do |spec|
  spec.name          = 'locasms'
  spec.version       = LocaSMS::VERSION
  spec.authors       = ['Adilson Carvalho', 'Leonardo Saraiva', 'Marco Carvalho']
  spec.email         = ['lc.adilson@gmail.com', 'vyper@maneh.org', 'marco.carvalho.swasthya@gmail.com']
  spec.description   = 'Cliente para o serviço de disparo de SMS da LocaSMS e de sua
                          versão para Short Code SMS (SMS Plataforma)'
  spec.summary       = 'Cliente para disparo de SMS, regular e Short Code, através da LocaSMS/SMS Plataforma'
  spec.homepage      = 'https://github.com/mcorp/locasms'
  spec.license       = 'MIT'
  spec.metadata      = { 'rubygems_mfa_required' => 'true' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'multi_json', '~> 1.13'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake',      '~> 13.0'

  # test stuff
  spec.add_development_dependency 'rspec',     '~> 3.11'
  spec.add_development_dependency 'timecop',   '~> 0.9'

  # for documentation
  spec.add_development_dependency 'yard',      '~> 0.9'

  # for code coverage
  spec.add_development_dependency 'simplecov', '~> 0.21'

  # for code quality
  spec.add_development_dependency 'rubocop', '~> 1.36'
  spec.add_development_dependency 'rubocop-performance', '~> 1.15'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.13'
end
