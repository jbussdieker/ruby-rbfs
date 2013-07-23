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
      "#{@host.ip}:#{@config[:remote_root]}"
    end

    def local_root
      if File.directory?(@config[:root])
        @config[:root] + "/"
      else
        @config[:root]
      end
    end

    def mkdir
      args = [@host.ip, "mkdir", "-p", @config[:remote_root]]
      command("ssh", args)
    end

    def rsync
      args = ["-ae", "ssh", "--delete", local_root, remote_url]
      args << "-v" if @config[:verbose]
      args << "-n" if @config[:dry]
      args << "--timeout=#{@config[:timeout]}" if @config[:timeout]
      command("rsync", args)
    end

    def sync
      if File.directory?(@config[:root])
        mkdir
      end
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
