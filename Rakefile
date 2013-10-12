require 'rubygems'
require 'bundler'

Bundler.setup
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'bundle exec irb -rubygems -I lib -r locasms.rb'
end

task :default => :console