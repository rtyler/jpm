require 'paint'
require 'thor'

require 'jpm'
require 'jpm/catalog'
require 'jpm/errors'

module JPM
  class CLI < Thor
    class_option :verbose, :type => :boolean,
                           :desc => 'Enable verbose output'
    class_option :offline, :type => :boolean,
                           :desc => 'Use `jpm` in a fully offline mode'

    def self.start(*args)
      begin
        super
      rescue JPM::Errors::CLIError => ex
        return 1
      end
      return 0
    end

    no_tasks do
      def require_network!
        if options[:offline]
          say 'This command cannot be run offline'
          raise JPM::Errors::CLINetwork
        end
      end

      def require_jenkins!
        unless JPM.installed?
          say "Jenkins is not installed!"
          raise JPM::Errors::CLIExit
        end
      end
    end

    desc 'list', "List the installed Jenkins plugins"
    def list
      require_jenkins!

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
    option :source, :type => :string,
                    :desc => 'Use a different update-center URL',
                    :default => JPM.update_center_url
    option :force, :type => :boolean,
                   :desc => 'Forcefully overwrite any existing repository'
    def update
      require_network!

      url = options[:source]

      if File.exists?(File.expand_path(JPM.repository_path))
        unless options[:force]
          force = ask('A version of the repo is already on disk, overwrite?',
                      :limited_to => ['y', 'n'])

          if force == 'n'
            raise JPM::Errors::CLIExit
          end
        end
      end

      say "Fetching <#{url}> ...\n\n"

      response = JPM.fetch(url)

      File.open(JPM.repository_path, 'w+') do |fd|
        fd.write(response.body)
      end

      say "Wrote to #{JPM.repository_path}"
    end


    desc 'install NAMES', 'Install the named plugins'
    def install(*names)
      require_jenkins!
      require_network!

      say "Loading plugin repository data...\n\n"

      catalog = JPM::Catalog.from_file(JPM.repository_path)

      installed = []

      names.each do |name|
        unless catalog[name]
          say "`#{name}` is not a plugin I'm familiar with!\n\n"
          say 'Use `jpm search TERM` to find the correct plugin name'
          raise JPM::Errors::CLIError
        end
      end


      computed = catalog.compute(names)
      catalog.install(computed) do |success, plugin|
        say "Installing #{plugin.name} v#{plugin.version} ...\n"
        installed << plugin
      end

      installed = installed.map { |p| "#{p.title} v#{p.version}" }
      say "\n#{installed.join(', ')} will be loaded on the next restart of Jenkins!"
    end
  end
end
