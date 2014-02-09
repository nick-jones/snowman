module Snowman
  class CLI
    def self.start
      value = ARGV[0]
      raise "A value must be supplied" unless value

      character = Character.new(value)
      raise "Value must be a single UTF-8 compatible character" unless character.valid?

      puts character
    end
  end
end