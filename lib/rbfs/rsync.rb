require 'rsync'

module Rbfs
  class Rsync
    def initialize(config = {}, host = nil)
      @config = config
      @host = host
    end

    def config
      @config
    end

    def logger
      config[:logger]
    end

    def sub_root(path)
      if config[:subpath]
        File.join(path, config[:subpath])
      else
        path
      end
    end

    def remote_url
      "#{@host.ip}:#{remote_root}"
    end

    def remote_root
      sub_root(config[:remote_root])
    end

    def local_root
      path = sub_root(config[:root])
      path += "/" if File.directory?(path)
      path
    end

    def mkdir
      args = [@host.ip, "mkdir", "-p", File.dirname(remote_root)]
      command("ssh", args)
    end

    def rsync
      args = ["-a", "--delete"]
      args << "-v" if config[:verbose]
      args << "-n" if config[:dry]
      args << "--timeout=#{config[:timeout]}" if config[:timeout]
      ::Rsync.run(local_root, remote_url, args)
    end

    def sync
      if config[:subpath]
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
