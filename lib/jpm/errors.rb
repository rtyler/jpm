module JPM
  module Errors
    class CLIError < StandardError; end;
    # Usad for controlling flow control in the CLI in a fashion that's suitable
    # for Aruba InProcess testing
    class CLIExit < CLIError; end;
    class CLINetwork < CLIError; end;

    class NetworkError < StandardError; end;
    class MissingCatalogError < StandardError; end;
    class InvalidCatalogError < StandardError; end;
    class InvalidPluginError < StandardError; end;
  end
end
