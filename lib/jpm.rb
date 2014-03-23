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
    return false if Dir.entries(self.plugins_dir) <= 2
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
    return File.join(self.plugins_dir, 'update-center.json')
  end
end
