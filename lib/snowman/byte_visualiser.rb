require 'colorize'

module Snowman
  class ByteVisualiser
    PART_COLOURS = {
        :leading => :red,
        :continuation => :yellow,
        :value => :green
    }

    def build(byte)
      @buffer = StringIO.new

      header(byte)
      @buffer << $/

      @buffer.string
    end

    protected

    def header(byte)
      @buffer << 'Decimal: ' << byte.value << $/
      @buffer << 'Hex: ' << byte.value.to_s(16).upcase << $/
      @buffer << 'Binary: ' << binary_colorized(byte) << $/
      @buffer << 'Type: ' << byte.type
      @buffer << ' (' << byte.high_order_bits.to_s.bold << ' bytes indicated)' if byte.leading?
      @buffer << $/
    end

    def binary_colorized(byte)
      result = ''

      resolve_components(byte).each do |part, bits|
        if part == :high_order
          part = byte.type == :ascii ? :leading : byte.type
        end

        color = PART_COLOURS[part]
        result += bits.colorize(color)
      end

      result
    end

    def resolve_components(byte)
      result = {:high_order => '', :value => ''}
      key = :high_order

      byte.value.to_s(2).rjust(8, '0').each_char do |char|
        result[key] += char
        key = :value if char.to_i == 0
      end

      result
    end
  end
end