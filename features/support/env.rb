require 'rubygems'
require 'aruba'
require 'aruba/cucumber'
require 'aruba/in_process'

require 'jpm/cli'

module JPM
  module Cucumber
    class ArubaShell < Thor::Shell::Basic
      attr_reader :stdin, :stdout, :stderr
      def initialize(stdin, stdout, stderr)
        super()
        @stdin = stdin
        @stdout = stdout
        @stderr
      end
    end

    class CLIRunner
      def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
        @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
      end

      def execute!
        JPM::CLI.start(@argv, :shell => ArubaShell.new(@stdin, @stdout, @stderr))
      end
    end
  end
end

Aruba::InProcess.main_class = JPM::Cucumber::CLIRunner
Aruba.process = Aruba::InProcess
