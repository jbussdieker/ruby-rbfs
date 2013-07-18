module Rbfs
  class Logger
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def info(msg)
      puts "\033[0;32m#{msg}" if config[:verbose]
    end

    def error(msg)
      puts "\033[0;31m#{msg}"
    end

    def critical(msg)
      puts "\033[0;31m#{msg}"
      exit 1
    end

    def notice(msg)
      puts "\033[0;33m#{msg}"
    end
  end
end
