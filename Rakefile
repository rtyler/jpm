require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'ci/reporter/rake/rspec'

RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = '--color --fail-fast --order random'
end


Cucumber::Rake::Task.new('cucumber')


task :default => [:spec, :cucumber, :build]
