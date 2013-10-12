# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locasms/version'

Gem::Specification.new do |spec|
  spec.name          = "locasms"
  spec.version       = Locasms::VERSION
  spec.authors       = ["Adilson Carvalho"]
  spec.email         = ["adilson@adilsoncarvalho.com.br"]
  spec.description   = %q{Cliente para o serviço de disparo de SMS da LocaSMS}
  spec.summary       = %q{Cliente para o serviço de disparo de SMS da LocaSMS}
  spec.homepage      = "https://github.com/mcorp/locasms"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
