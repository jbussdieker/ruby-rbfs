module Rbfs
  module Rsync
    def sync(config)
      command = "rsync -ave ssh --delete #{config[:root]} #{ip}:#{config[:root]}"
      command += " -n" if config[:dry]
      result = `#{command}`
      puts result if config[:verbose]
    end
  end
end
