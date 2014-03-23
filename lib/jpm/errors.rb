module JPM
  module Errors
    # Usad for controlling flow control in the CLI in a fashion that's suitable
    # for Aruba InProcess testing
    class CLIExit < StandardError; end;
    class CLIError < StandardError; end;

    class NetworkError < StandardError; end;
    class MissingCatalogError < StandardError; end;
    class InvalidCatalogError < StandardError; end;
    class InvalidPluginError < StandardError; end;
  end
end
