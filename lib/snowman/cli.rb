module Snowman
  class CLI
    def self.start
      value = ARGV[0]
      length = value.length
      br = $/ + ('─' * 58) + $/ + $/

      raise 'A value must be supplied' unless length > 0

      value.each_char.with_index(1) do |char, i|
        puts Character.new(char)
        puts br unless i == length
      end
    end
  end
end