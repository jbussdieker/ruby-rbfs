module Rbfs
  class Rsync
    def initialize(config = {}, host = nil)
      @config = config
      @host = host
    end

    def logger
      @config[:logger]
    end

    def remote_url
      "#{@host.ip}:#{@config[:root]}"
    end

    def mkdir
      args = [remote_url, "mkdir", "-p", @config[:root]]
      command("ssh", args)
    end

    def rsync
      args = ["-ae", "ssh", "--delete", @config[:root], remote_url]
      args << "-v" if @config[:verbose]
      args << "-n" if @config[:dry]
      args << "--timeout=#{@config[:timeout]}" if @config[:timeout]
      command("rsync", args)
    end

    def sync
      mkdir
      rsync
    end

    def command(cmd, options = [], &block)
      cmd_line = "#{cmd} "
      cmd_line += options.join(' ')
      output = run_command(cmd_line, &block)
      exitcode = $?
      {:output => output, :exitcode => exitcode}
    end

    def run_command(cmd, &block)
      if block_given?
        IO.popen("#{cmd} 2>&1", &block)
      else
        `#{cmd} 2>&1`
      end
    end
  end
end
