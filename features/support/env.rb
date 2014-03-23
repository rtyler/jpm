require 'rubygems'
require 'cucumber/rspec/doubles'

require 'jpm/cli'

unless RUBY_PLATFORM == 'java'
  require 'debugger'
  require 'debugger/pry'
end

