module Snowman
  class Character
    # Sets up the character. The value is stored, and byte instances are created.
    def initialize(value)
      @value = value
      @bytes = value.bytes.map{ |b| Byte.new(b) }
    end

    # Original supplied value.
    def value
      @value
    end

    # The size of the character, in bytes
    def size
      @value.bytesize
    end

    # Whether this is a valid UTF-8 character
    def utf8?
      @value.encoding.name == "UTF-8"
    end

    # Whether this is an ASCII compatible character (assuming 7-bit)
    def ascii_compatible?
      size == 1
    end

    # Accessor for the character Byte instances
    def bytes
      @bytes
    end

    # Whether the held value is a single valid UTF-8 character
    def valid?
      utf8? && @value.length == 1
    end

    # Convenience function to retrieve the leading byte
    def leading_byte
      bytes.first
    end

    # Extracts the value bits from the contained bytes
    def value_bits
      bytes.map{ |byte| byte.components[:value] }.join("")
    end

    # Builds a string representation of this character
    def to_s
      CharacterVisualiser.new.build(self)
    end
  end
end