require 'rbfs/rsync'

module Rbfs
  class Host
    include Rsync

    def initialize(raw)
      @raw = raw
    end

    def ip
      @raw.split.first
    end

    def to_s
      name
    end

    def name
      @raw.split[1]
    end
  end
end
