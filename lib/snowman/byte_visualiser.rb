require 'colorize'

module Snowman
  class ByteVisualiser
    # Byte parts -> colour mappings.
    PART_COLOURS = {
        :leading => :red,
        :continuation => :yellow,
        :value => :green
    }

    # Builds a description of the supplied byte, containing various pieces of relevant information.
    def build(byte)
      @buffer = StringIO.new

      header(byte)
      @buffer << $/

      @buffer.string
    end

    # Adds basic information about the byte to the string buffer.
    def header(byte)
      @buffer << 'Decimal: ' << byte.value << $/
      @buffer << 'Hex: ' << byte.value.to_s(16).upcase << $/
      @buffer << 'Binary: ' << binary_colorized(byte) << $/
      @buffer << 'Type: ' << byte.type
      @buffer << ' (' << byte.high_order_bits.to_s.bold << ' bytes indicated)' if byte.leading?
      @buffer << $/
    end

    # Builds a binary representation of the byte, with the components colored appropriately.
    def binary_colorized(byte)
      result = ''

      byte.components.each do |component, bits|
        color = component == :high_order ? PART_COLOURS[byte.type] : PART_COLOURS[component]
        result += bits.colorize(color)
      end

      result
    end
  end
end