require 'jpm'

module JPM
  class Manifest < Hash
      # Return structured data for the given plugin manifest string
      #
      # @return [Hash] A hash containing symbolized manifest keys and their
      #   string values
      # @return [NilClass] A nil if +manifest_str+ nil or an empty string
      def self.from_manifest(manifest_str)
        data = self.new
        return data if (manifest_str.nil? || manifest_str.empty?)

        manifest_str.split("\n").each do |line|
          next if line.empty?
          # Parse out "Plugin-Version: 1.2" for example
          parts = line.split(': ')

          # If the line starts with a space or we can't get at least two parts
          # (key and value), that means it's really just a word-wrap from the
          # previous line, and not a key, skip!
          next if parts.size < 2
          next if parts.first[0] == ' '

          key = parts.first.downcase.gsub('-', '_').chomp
          # Skip garbage keys
          next if (key.nil? || key.empty?)

          # Re-join any colon delimited strings in the value back together,
          # e.g.: "http://wiki.jenkins-ci.org/display/JENKINS/Ant+Plugin"
          value = parts[1..-1].join(':').chomp

          data[key.to_sym] = value
        end

        return data
      end
  end
end
