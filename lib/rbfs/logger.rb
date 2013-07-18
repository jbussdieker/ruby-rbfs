module Rbfs
  class Logger
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def info(msg)
      puts "\033[0;32m#{msg}\033[00masdf"
    end

    def error(msg)
      puts "\033[0;31m#{msg}\033[00m"
    end

    def critical(msg)
      puts "\033[0;31m#{msg}\033[00m"
      exit 1
    end

    def notice(msg)
      puts "\033[0;33m#{msg}\033[00m"
    end
  end
end
