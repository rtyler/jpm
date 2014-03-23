require 'aruba'
require 'aruba/cucumber'
require 'aruba/in_process'


# Forcing the Readline editor to be unavailable regardless of whether the
# 'readline' module exists or not. This will make sure our mucking with $stdin
# works out properly in the Aruba::InProcess runner
class Thor
  module LineEditor
    class Readline
      def self.available?
        false
      end
    end
  end
end

module JPM
  module Cucumber
    class CLIRunner
      attr_reader :stdin

      def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
        @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
      end

      def execute!
        # Borrowed from
        # <https://github.com/erikhuda/thor/wiki/Integrating-with-Aruba-In-Process-Runs>
        exit_code = begin
                      # Thor accesses these streams directly rather than
                      # letting them be injected, so we replace them...
                      $stderr = @stderr
                      $stdin = @stdin
                      $stdout = @stdout

                      # Run our normal Thor app the way we know and love.
                      JPM::CLI.start(@argv)

                      # Thor::Base#start does not have a return value, assume
                      # success if no exception is raised.
                      0
                    rescue Exception => ex
                      # Proxy any exception that comes out of Thor itself back
                      # to stderr
                      $stderr.write(ex.message + "\n")
                      1
                    ensure
                      $stderr = STDERR
                      $stdin = STDERR
                      $stdout = STDERR
                    end

        @kernel.exit(exit_code)
      end
    end
  end
end

Aruba::InProcess.main_class = JPM::Cucumber::CLIRunner
Aruba.process = Aruba::InProcess
