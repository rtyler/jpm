require 'jpm'
require 'thor'

module JPM
  class CLI < Thor
    desc 'list', "List the installed Jenkins plugins"
    def list
      if JPM.installed?
        if JPM.has_plugins?
          plugins = JPM.plugins.sort do |x, y|
            x[:name] <=> y[:name]
          end
          plugins.each do |plugin|
            say(" - #{plugin[:name]} (#{plugin[:version]})")
          end
        else
          say 'No plugins found'
        end
      else
        say "Jenkins is not installed!"
      end
    end
  end
end
