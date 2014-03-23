module JPM
  module Errors
    class MissingCatalogError < StandardError; end;
    class InvalidCatalogError < StandardError; end;
    class InvalidPluginError < StandardError; end;
  end
end
