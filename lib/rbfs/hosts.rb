require "rbfs/host"
require "rbfs/rsync"

module Rbfs
  class Hosts
    include Enumerable

    def initialize(config)
      @config = config
      @file_name = config[:hosts]
    end
    
    def each(&block)
      lines = File.read(@file_name).split("\n")
      lines.reject! {|line| line.strip.start_with? "#"}
      lines.each do |line|
        yield(Host.new(line))
      end
    end

    def sync
      if @config[:threaded]
        sync_nonblocking
      else
        sync_blocking
      end
    end

    def sync_blocking
      collect do |host|
        puts "#{host} (#{host.ip})" if @config[:verbose]
        [host, Rsync.new(host, @config).sync]
      end
    end

    def sync_nonblocking
      require 'rbfs/futures'

      collect do |host|
        puts "#{host} (#{host.ip})" if @config[:verbose]
        Future.new do
          [host, Rsync.new(host, @config).sync]
        end
      end
    end
  end
end
