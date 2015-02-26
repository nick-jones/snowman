module Snowman
  class CLI
    def self.start
      value = ARGV[0]

      raise 'A value must be supplied' unless value
      raise 'A single character must be supplied' unless value.length == 1

      puts Character.new(value)
    end
  end
end