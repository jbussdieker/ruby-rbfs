require "rbfs/host"

module Rbfs
  class Hosts
    def initialize(file_name)
      @file_name = file_name
    end
    
    def each(&block)
      lines = File.read(@file_name).split("\n")
      lines.reject! {|line| line.strip.start_with? "#"}
      lines.each do |line|
        yield(Host.new(line))
      end
    end
  end
end
