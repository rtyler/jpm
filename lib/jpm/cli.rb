require 'thor'

module JPM
  class CLI < Thor
    desc 'list', "List the installed Jenkins plugins"
    def list
      say "Jenkins is not installed!"
    end
  end
end
