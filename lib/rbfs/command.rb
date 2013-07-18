require 'rbfs/args'
require 'rbfs/config'
require "rbfs/host_parser"
require "rbfs/rsync"
require "rbfs/futures"

module Rbfs
  class Command
    def self.parse_config
      args = Rbfs::Args.new.parse
      if args[:config]
        options = Rbfs::Config.new(args[:config]).parse
        options.merge(args)
      else
        args
      end
    end

    def self.sync(config)
      config[:root] = File.join(config[:root], config[:subpath]) if config[:subpath]
      puts "Syncing #{config[:root]}..." if config[:verbose]
      hosts = Rbfs::HostParser.new(File.open(config[:hosts]))
      hosts.collect do |host|
        [host, sync_host(config, host)]
      end
    end

    def self.sync_host(config, host)
      if config[:threaded]
        Future.new do
          Rsync.new(config, host).sync
        end
      else
        Rsync.new(config, host).sync
      end
    end
  end
end
