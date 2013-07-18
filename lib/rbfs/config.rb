require 'yaml'

module Rbfs
  class Config
    def initialize(file_name = "/etc/rbfs.yml")
      @file_name = file_name
    end

    def parse
      YAML.load(File.read(@file_name))
    end
  end
end
