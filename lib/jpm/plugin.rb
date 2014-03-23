require 'jpm'
require 'jpm/errors'

module JPM
  class Plugin
    attr_accessor :name, :title, :version, :wiki, :labels

    # Return a formatted string representing an abbreviated format of this
    # plugin
    #
    # @return [String]
    def shortform
      return "#{@title} (#{@name})
  version: v#{@version}
   labels: #{@labels.join(', ')}
     wiki: <#{@wiki}>"
    end

    # Create a +JPM::Plugin+ object from the +Hash+ provided by the update
    # center. This allows +JPM::Catalog+ to work with us
    #
    # @param [Hash] plugin_data Parsed meta-data from an update-center.json file
    # @return [JPM::Plugin]
    def self.from_hash(plugin_data)
      if plugin_data.nil? || !plugin_data.instance_of?(Hash) || plugin_data.empty?
        raise JPM::Errors::InvalidPluginError
      end

      plugin = self.new
      plugin.name = plugin_data['name']
      plugin.title = plugin_data['title']
      plugin.labels = plugin_data['labels']
      plugin.version = plugin_data['version']
      plugin.wiki = plugin_data['wiki']
      return plugin
    end
  end
end
