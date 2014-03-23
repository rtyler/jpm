require 'net/http'
require 'uri'

require 'jpm/errors'

module JPM
  # @return [Boolean] True if Jenkins is properly installed
  def self.installed?
    !self.home_dir.nil?
  end

  # @return [String] Full path to the Jenkins user's home directory
  def self.home_dir
    begin
      return File.expand_path('~jenkins')
    rescue ArgumentError => ex
      # The Jenkins user doesn't exist!
      return nil
    end
  end

  # @return [String] Full path to the Jenkins user's plugin directory
  def self.plugins_dir
    return File.join(self.home_dir || '', 'plugins')
  end

  # @return [Boolean] True if the +plugins_dir+ exists and contents
  def self.has_plugins?
    # If the path isn't a valid directory, false
    return false unless File.directory? self.plugins_dir
    # If the directory doesn't have more than ['.', '..'] in it, false
    return false if Dir.entries(self.plugins_dir).size <= 2
    return true
  end

  def self.plugins
    return [] unless self.has_plugins?
    plugins = []
    Dir.entries(self.plugins_dir).each do |plugin|
      # Skip useless directories
      next if (plugin == '..')
      next if (plugin == '.')

      plugin_dir = File.join(self.plugins_dir, plugin)
      # Without an unpacked plugin directory, we can't find a version
      next unless File.directory?(plugin_dir)

      plugins << plugin
    end
    return plugins
  end

  def self.repository_path
    return File.join(self.home_dir, 'update-center.json')
  end

  def self.update_center_url
    return "http://updates.jenkins-ci.org/update-center.json"
  end

  def self.fetch(uri_str, limit = 10)
    if limit == 0
      raise JPM::Errors::NetworkError, "Too many HTTP redirects while trying to fetch `#{url_str}`"
    end

    response = Net::HTTP.get_response(URI(uri_str))

    case response
    when Net::HTTPSuccess then
      response
    when Net::HTTPRedirection then
      location = response['location']
      fetch(location, limit - 1)
    else
      response.value
    end
  end

end
