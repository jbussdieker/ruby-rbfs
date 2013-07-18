module Rbfs
  class Rsync
    def initialize(config = {}, host = nil)
      @config = config
      @host = host
    end

    def sync
      args = ["-ae", "ssh", "--delete", @config[:root], "#{@host.ip}:#{@config[:root]}"]
      args << "-v" if @config[:verbose]
      args << "-n" if @config[:dry]
      output = command("rsync", args)
      exitcode = $?
      {:output => output, :exitcode => exitcode}
    end

    def command(cmd, options = [], &block)
      cmd_line = "#{cmd} "
      cmd_line += options.join(' ')
      run_command(cmd_line, &block)
    end

    def run_command(cmd, &block)
      if block_given?
        IO.popen(cmd, &block)
      else
        `#{cmd}`
      end
    end
  end
end
