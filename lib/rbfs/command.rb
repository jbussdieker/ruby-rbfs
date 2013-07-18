require 'rbfs/args'
require 'rbfs/config'
require "rbfs/host_parser"
require "rbfs/rsync"
require "rbfs/futures"
require "rbfs/logger"

module Rbfs
  class Command
    attr_accessor :config

    def initialize
      @config = parse_config
      logger.critical "No hosts file specified" unless config[:hosts]
      logger.critical "Root path not specified" unless config[:root]
    end

    def parse_config
      config = {}
      cmdline_args = Rbfs::Args.new.parse
      if cmdline_args[:config]
        config_args = Rbfs::Config.new(cmdline_args[:config]).parse
        config = config_args.merge(cmdline_args)
      else
        config = cmdline_args
      end
      config[:logger] = Logger.new(config)
      config
    end

    def logger
      @config[:logger]
    end

    def sync
      success = true
      results = sync_hosts
      results.each do |host, result|
        if result[:exitcode] != 0
          logger.error "#{host}: #{result[:exitcode].to_i}"
        else
          logger.info "#{host}: #{result[:exitcode].to_i}"
        end
        result[:output].split("\n").each do |line|
          logger.puts "  | #{line}"
        end
        success = false if result[:exitcode] != 0
      end
      success
    end

    def sync_hosts
      config[:root] = File.join(config[:root], config[:subpath]) if config[:subpath]
      logger.info "Syncing #{config[:root]}..."
      hosts = Rbfs::HostParser.new(File.open(config[:hosts]))
      hosts.collect do |host|
        [host, sync_host(host)]
      end
    end

    def sync_host(host)
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
