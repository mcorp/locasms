# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locasms/version'

Gem::Specification.new do |spec|
  spec.name          = "locasms"
  spec.version       = LocaSMS::VERSION
  spec.authors       = ["Adilson Carvalho", "Leonardo Saraiva", "Marco Carvalho"]
  spec.email         = ["lc.adilson@gmail.com", "vyper@maneh.org", "marco.carvalho.swasthya@gmail.com"]
  spec.description   = %q{Cliente para o serviço de disparo de SMS da LocaSMS e de sua 
                          versão para Short Code SMS (SMS Plataforma)}
  spec.summary       = %q{Cliente para disparo de SMS, regular e Short Code, através da LocaSMS/SMS Plataforma}
  spec.homepage      = "https://github.com/mcorp/locasms"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.4.2'

  # test stuff
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'fuubar', '~> 2.0.0'
  spec.add_development_dependency 'timecop', '~> 0.7.3'

  # run tests automatically
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'growl'

  # for documentation
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'

  # for code coverage
  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'rest-client', '~> 1.6'
end
