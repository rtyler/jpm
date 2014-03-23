module JPM
  module Errors
    class NetworkError < StandardError; end;
    class MissingCatalogError < StandardError; end;
    class InvalidCatalogError < StandardError; end;
    class InvalidPluginError < StandardError; end;
  end
end
