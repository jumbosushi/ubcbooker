require "bundler/gem_tasks"
require "rspec/core/rake_task"

ENV['RACK_ENV'] == 'test'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
