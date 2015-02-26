module Snowman
  class Character
    def initialize(value)
      @value = value
      verify_value
      @bytes = value.bytes.map{ |b| Byte.new(b) }
      @codepoint = codepoint_from_bytes(@bytes)
      verify_codepoint
    end

    def value
      @value
    end

    def size
      @value.bytesize
    end

    def utf8?
      @value.encoding.name == 'UTF-8'
    end

    def ascii_compatible?
      size == 1
    end

    def bytes
      @bytes
    end

    def valid?
      utf8? && @value.length == 1
    end

    def leading_byte
      @bytes.first
    end

    def codepoint
      @codepoint
    end

    def plane
      if @codepoint.between?(0x0000, 0xFFFF)
        :bmp
      elsif @codepoint.between?(0x10000, 0x1FFFF)
        :smp
      elsif @codepoint.between?(0x20000, 0x2FFFF)
        :sip
      elsif @codepoint.between?(0xE0000, 0xEFFFF)
        :ssp
      elsif @codepoint.between?(0xF0000, 0xFFFFF)
        :puaa
      elsif @codepoint.between?(0x100000, 0x10FFFF)
        :puab
      end
    end

    def to_s
      CharacterVisualiser.new.build(self)
    end

    protected

    def codepoint_from_bytes(bytes)
      result = offset = 0

      bytes.reverse_each do |byte|
        result += byte.value_portion << offset
        offset += 7 - byte.high_order_bits
      end

      result
    end

    def verify_value
      unless valid?
        raise 'Value must be a single UTF-8 character'
      end
    end

    def verify_codepoint
      unless @codepoint == @value.codepoints.first
        raise 'Failed to resolve codepoint correctly'
      end
    end
  end
end