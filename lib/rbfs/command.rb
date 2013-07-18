require 'rbfs/args'
require 'rbfs/config'

module Rbfs
  class Command
    def self.config
      args = Rbfs::Args.new.parse
      if args[:config]
        options = Rbfs::Config.new(args[:config]).parse
        options.merge(args)
      else
        args
      end
    end
  end
end
