require 'rubygems'
require 'rspec'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))


unless RUBY_PLATFORM == 'java'
  require 'debugger'
  require 'debugger/pry'
end

