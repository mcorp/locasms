# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locasms/version'

Gem::Specification.new do |spec|
  spec.name          = 'locasms'
  spec.version       = LocaSMS::VERSION
  spec.authors       = ['Adilson Carvalho', 'Leonardo Saraiva', 'Marco Carvalho']
  spec.email         = ['lc.adilson@gmail.com', 'vyper@maneh.org', 'marco.carvalho.swasthya@gmail.com']
  spec.description   = %q(Cliente para o serviço de disparo de SMS da LocaSMS e de sua
                          versão para Short Code SMS (SMS Plataforma))
  spec.summary       = %q(Cliente para disparo de SMS, regular e Short Code, através da LocaSMS/SMS Plataforma)
  spec.homepage      = 'https://github.com/mcorp/locasms'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.4'

  spec.add_dependency 'multi_json', '~> 1.13'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake',      '~> 13.0'

  # test stuff
  spec.add_development_dependency 'rspec',     '~> 3.9'
  spec.add_development_dependency 'timecop',   '~> 0.9'

  # for documentation
  spec.add_development_dependency 'yard',      '~> 0.9'
  spec.add_development_dependency 'redcarpet', '~> 3.5'

  # for code coverage
  spec.add_development_dependency 'simplecov', '~> 0.18'

  # for code quality
  spec.add_development_dependency 'rubocop',   '~> 0.93'
end
