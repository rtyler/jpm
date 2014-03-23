require 'paint'
require 'thor'

require 'jpm'
require 'jpm/catalog'

module JPM
  class CLI < Thor
    class_option :verbose, :type => :boolean,
                           :banner => 'Enable verbose output'
    class_option :offline, :type => :boolean,
                           :banner => 'Use `jpm` in a fully offline mode'

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

    desc 'search TERM', 'Search for available plugins'
    def search(term)
      say "Loading plugin repository data...\n\n"

      catalog = JPM::Catalog.from_file(JPM.repository_path)

      catalog.search(term) do |plugin|
        say "- #{plugin.shortform}\n\n"
      end
    end

    desc 'update', 'Update the local plugin repository meta-data'
    def update
      say "Fetching <#{JPM.update_center_url}> ...\n\n"

      response = JPM.fetch(JPM.update_center_url)

      File.open(JPM.repository_path, 'w+') do |fd|
        fd.write(response.body)
      end

      say "Wrote to #{JPM.repository_path}"
    end
  end
end
