require 'rbfs/args'
require 'rbfs/config'
require "rbfs/host_parser"
require "rbfs/rsync"
require "rbfs/futures"
require "rbfs/logger"

module Rbfs
  class Command
    attr_accessor :config

    def initialize(config = nil)
      if config
        @config = config
      else
        @config = parse_config unless config
      end
      @config[:logger] = Logger.new(@config)
      logger.critical "No hosts file specified" unless @config[:hosts]
      logger.critical "Root path not specified" unless @config[:root]
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
      unless config[:remote_root]
        config[:remote_root] = config[:root]
      end
      config
    end

    def logger
      @config[:logger]
    end

    def sync
      success = true
      results = sync_hosts
      results.each do |host, result|
        if result.success?
          logger.info "#{host}: #{result.error}"
        else
          logger.error "#{host}: #{result.error}"
        end
        result.changes.each do |change|
          logger.puts "  | #{change.filename} (#{change.summary})"
        end
        success = false unless result.success?
      end
      success
    end

    def sync_hosts
      if config[:subpath]
        config[:root] = File.join(config[:root], config[:subpath])
        config[:remote_root] = File.join(config[:remote_root], config[:subpath])
      end

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
