require 'rbfs/args'
require 'rbfs/config'

module Rbfs
  class Command
    def self.config
      args = Rbfs::Args.new.parse
      options = Rbfs::Config.new(args[:config]).parse
      options.merge(args)
    end
  end
end
