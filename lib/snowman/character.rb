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
      @value.encoding.name == 'UTF-8'
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
      bytes.map{ |byte| byte.components[:value] }.join('')
    end

    # Indicates the plane in which this character resides
    def plane
      codepoint = @value.codepoints.first

      if codepoint.between?(0x0000, 0xFFFF)
        :bmp
      elsif codepoint.between?(0x10000, 0x1FFFF)
        :smp
      elsif codepoint.between?(0x20000, 0x2FFFF)
        :sip
      elsif codepoint.between?(0xE0000, 0xEFFFF)
        :ssp
      elsif codepoint.between?(0xF0000, 0x10FFFF)
        :pua
      end
    end

    # Builds a string representation of this character
    def to_s
      CharacterVisualiser.new.build(self)
    end
  end
end