require 'forwardable'
require 'json'

require 'jpm'
require 'jpm/errors'
require 'jpm/plugin'

module JPM
  class Catalog
    extend Forwardable

    attr_reader :plugins

    # Dekegate the #size method to our plugins hash
    def_delegator :@plugins, :size
    def_delegator :@plugins, :[]

    def initialize(options={})
      super()
      @plugins = {}
    end

    # Append a +JPM::Plugin+ to the catalog
    #
    # @param [JPM::Plugin] plugin
    # @return [JPM::Catalog]
    def <<(plugin)
      # We're overriding this method instead of delegating it to the @plugins
      # instance method to make sure that we're structuring our +Hash+
      # correctly, and only inserting valid +JPM::Plugin+ objects
      unless plugin.instance_of? JPM::Plugin
        raise ArgumentError, "`plugin` must be an instance of JPM::Plugin"
      end

      @plugins[plugin.name] = plugin

      return self
    end

    # Compute the installation manifest for the specified plugins
    #
    # @param [Array] plugins Collection of +String+ objects which are Jenkins
    #   plugin names (e.g. 'git-client')
    # @return [Array] ordered list of plugins to install
    def compute(names)
      plugins = []
      if names.nil? || names.empty?
        return plugins
      end

      names.each do |name|
        plugin = self[name]
        next if plugin.nil?

        # Let's recurse down into our dependencies first and get our
        # dependencies before we add ourselves
        unless plugin.dependencies.empty?
          dep_names = plugin.dependencies.map { |p| p.name }
          plugins = compute(dep_names) + plugins
        end

        plugins << plugin
      end

      # We need to uniq ehre on plugin name to make sure don't download thing
      # over and over again!
      return plugins.uniq { |p| p.name }
    end

    # Install an +Array+ of +JPM::Plugin+ objects which have already had their
    # dependencies computed for us
    #
    # @param [Array] computed Array of +JPM::Plugin+ objects
    # @yield [JPM::Plugin] An instance of the installed plugin
    # @return [Boolean] True if all plugins were installed successfully
    def install(computed_list)
      computed_list.each do |plugin|
        status = download(plugin)
        yield status, plugin
      end

      return true
    end

    # Search our loaded catalog for the named plugin
    #
    # @param [String] term
    # @yield [JPM::Plugin] If passed a block, will yield each +JPM::Plugin+
    #   search result to it
    # @return [Array] Array of +JPM::Plugin+ objects if no block given
    def search(term)
      results = []
      @plugins.each_pair do |name, plugin|
        if name.match(term)
          if block_given?
            yield plugin
          else
            results << plugin
          end
        end
      end

      return results
    end

    # Create an instance of a catalog from a file on the current system's disk
    #
    # @param [String] filepath Absolute path to an update-center.json file
    # @return [JPM::Catalog] instance of a Catalog
    def self.from_file(filepath)
      catalog = self.new

      unless File.exists?(filepath)
        raise JPM::Errors::MissingCatalogError, "`#{filepath}` is not a valid file"
      end

      plugins = []
      File.open(filepath, 'rb') do |fd|
        buffer = fd.read
        raise JPM::Errors::InvalidCatalogError if (buffer.nil? || buffer.empty?)
        buffer = buffer.split("\n")
        # Trim off the first and last lines, which are the JSONP gunk
        buffer = buffer[1 ... -1]

        data = JSON.parse(buffer.join("\n"))
        plugins = data['plugins']
      end

      # The plugin data is in the form of a +Hash+, in that it looks something
      # like this:
      #   {
      #     "git" => {
      #       "name" => "git",
      #       "version" => "1.0"
      #     }
      #   }
      plugins.each do |name, plugin|
        catalog << JPM::Plugin.from_hash(plugin)
      end

      return catalog
    end

    private

    # Download and save a single plugin
    #
    # @param [JPM::Plugin] plugin
    # @return [Boolean] True if the plugin was successfully downloaded
    def download(plugin)
      response = JPM.fetch(plugin.url)
      filename = File.basename(plugin.url)

      return save_plugin(filename, response.body)
    end

    # Write a plugin's data to the filename on disk.
    #
    # This method will resolve an absolute path using +JPM.plugins_dir+
    #
    # @param [String] filename The plugin file's name (e.g. "git.hpi")
    # @param [String contents Raw file contents
    # @return [Boolean]
    def save_plugin(filename, contents)
      File.open(File.join(JPM.plugins_dir, filename), 'wb+') do |fd|
        fd.write(contents)
      end
      return true
    end
  end
end
