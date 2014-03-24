require 'jpm'

module JPM
  # Simple object representation of a dependency for a plugin from the update
  # center
  class Dependency
    attr_reader :name, :min_version

    def initialize(name, version, optional)
      @name = name
      @min_version = version
      @option = optional
    end

    def optional?
      return @optional
    end

    # Parse a +Hash+ from the update center to an object representation of that
    # dependency
    #
    # @param [Hash] data Hash containing +name+, +version+, and +optional+ keys
    # @return [JPM::Dependency]
    def self.from_hash(data)
      return self.new(data['name'], data['version'], data['optional'])
    end
  end
end
