module Rbfs
  class Rsync
    def initialize(host, config)
      @host = host
      @config = config
    end

    def sync
      command = "rsync -ave ssh --delete #{@config[:root]} #{@host.ip}:#{@config[:root]}"
      command += " -n" if @config[:dry]
      result = `#{command}`
      puts result if @config[:verbose]
      $?
    end
  end
end
