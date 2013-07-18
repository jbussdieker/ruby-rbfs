require "rbfs/host"

module Rbfs
  class HostParser
    include Enumerable

    def initialize(file)
      @file = file
    end
    
    def each(&block)
      lines = @file.read.split("\n")
      lines.reject! {|line| line.strip.start_with? "#" }
      lines.reject! {|line| line.strip.empty? }
      lines.each do |line|
        yield(Host.new(line))
      end
    end
  end
end
