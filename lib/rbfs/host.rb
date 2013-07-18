module Rbfs
  class Host
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

    def alias
      @raw.split[2]
    end
  end
end
