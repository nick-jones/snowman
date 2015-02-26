module Snowman
  class Byte
    def initialize(value)
      @value = value
      @high_order_bits = number_of_high_order_bits(value)
      @value_portion = calculate_value_portion(value, high_order_bits)
    end

    def value
      @value
    end

    def high_order_bits
      @high_order_bits
    end

    def value_portion
      @value_portion
    end

    def ascii?
      type == :ascii
    end

    def continuation?
      type == :continuation
    end

    def leading?
      type == :leading
    end

    def type
      case @high_order_bits
        when 0
          :ascii # No high order bits implies a 7-bit ASCII character.
        when 1
          :continuation # A single high order bit implies a continuation byte.
        else
          :leading # More than 1 implies the leading bit; this cannot happen under any other circumstance.
      end
    end

    def to_s
      ByteVisualiser.new.build(self)
    end

    protected

    def number_of_high_order_bits(value)
      x = 0

      # Locate the first 0; this is a achieved by left shifting by x++ until the msb 2^7 (128) is 0.
      until ((value << x) & 128) == 0 do
        x += 1
      end

      x
    end

    def calculate_value_portion(value, high_order_bits)
      # Replaces the high order bits with 0s
      high_order = 256 - (2 ** (8 - high_order_bits))
      value ^ high_order
    end
  end
end