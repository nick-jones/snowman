module Snowman
  class Byte
    # Sets up the instance. The high order bit count is calculated, and the component parts (high order bits, value
    # bits) of the byte are extracted.
    def initialize(value)
      @value = value
      @high_order_bits = calculate_high_order_bits
      @components = resolve_components
    end

    # The original supplied value.
    def value
      @value
    end

    # Total number of high order "1" bits.
    def high_order_bits
      @high_order_bits
    end

    # Hash containing the byte split into the component parts; keys are :high_order and :value.
    def components
      @components
    end

    # Indicates whether this is a 7-bit compatible ASCII byte.
    def ascii?
      type == :ascii
    end

    # Indicates whether this is a continuation byte.
    def continuation?
      type == :continuation
    end

    # Indicates whether this is the leading byte.
    def leading?
      type == :leading
    end

    # Determines the type of this byte (in the UTF-8 context..)
    def type
      case @high_order_bits
        # No high order bits implies a 7-bit ASCII character.
        when 0
          :ascii
        # A single high order bit implies a continuation byte.
        when 1
          :continuation
        # More than 1 implies the leading bit; this cannot happen under any other circumstance.
        else
          :leading
      end
    end

    # Converts this byte into a string based representation.
    def to_s
      ByteVisualiser.new.build(self)
    end

    protected

    # Extracts the high order and value components from the binary representation of the value.
    def resolve_components
      result = {:high_order => "", :value => ""}
      key = ascii? ? :value : :high_order

      @value.to_s(2).rjust(8, "0").each_char do |char|
        result[key] += char
        key = :value if char.to_i == 0
      end

      result
    end

    # Calculates the number of high order "1s".
    def calculate_high_order_bits
      x = 0

      # Locate the first 0; this is a achieved by left shifting by x++ until the msb 2^7 (128) is 0.
      until ((@value << x) & 128) == 0 do
        x += 1
      end

      x
    end
  end
end