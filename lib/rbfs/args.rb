require 'optparse'

module Rbfs
  class Args
    def parse
      options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: rbfs [options]"
        opts.on("-c", "--config FILE", "Configuration file") do |v|
          options[:config] = v
        end
        opts.on("-h", "--hosts FILE", "Hosts file") do |v|
          options[:hosts] = v
        end
        opts.on("-r", "--root ROOT", "Root path to sync") do |v|
          options[:root] = v
        end
        opts.on("-e", "--remote-root ROOT", "Remote root path to sync") do |v|
          options[:remote_root] = v
        end
        opts.on("-s", "--subpath PATH", "Subpath of root to sync") do |v|
          options[:subpath] = v
        end
        opts.on("-v", "--[no-]verbose", "Print extra debugging info") do |v|
          options[:verbose] = v
        end
        opts.on("-d", "--dry", "Test config settings") do |v|
          options[:dry] = v
        end
        opts.on("-t", "--[no-]threaded", "Run all hosts concurrently") do |v|
          options[:threaded] = v
        end
        opts.on("--timeout TIMEOUT", "Set I/O timeout") do |v|
          options[:timeout] = v
        end
      end.parse!

      options
    end
  end
end
