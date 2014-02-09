require 'stringio'
require 'colorize'

module Snowman
  class CharacterVisualiser
    # Builds a string based representation of the supplied character, containing relevant information.
    def build(character)
      @buffer = StringIO.new

      @buffer << "Supplied".cyan.bold << "\n"
      header(character)
      @buffer << "\n"

      @buffer << "Details".cyan.bold << "\n"
      basic_details(character)
      @buffer << "\n"

      @buffer << "Breakdown".cyan.bold << "\n"
      byte_color_details
      @buffer << "\n"

      character.bytes.each_with_index do |byte, i|
        @buffer << " Byte #{(i+1).to_s}".blue.bold << "\n"
        byte_details(byte)
      end

      @buffer << "Value".cyan.bold << "\n"
      value_details(character)

      @buffer.string
    end

    # Adds information about the value to the buffer.
    def header(character)
      @buffer << " Character: " << character.value << "\n"
    end

    # Adds basic details about the character to the buffer.
    def basic_details(character)
      @buffer << " Bytes: " << character.size << "\n"
      @buffer << " Hex: " << character.bytes.map{ |byte| byte.value.to_s(16) }.join(" ").upcase << "\n"
      @buffer << " ASCII compatible: " << character.ascii_compatible? << "\n"
    end

    # Builds information about the supplied byte.
    def byte_details(byte)
      # Extra indentation is required
      byte.to_s.lines.each do |line|
        @buffer << "  " << line
      end
    end

    # A basic helper key for the various colours used.
    def byte_color_details
      @buffer << " (bit colorings: "

      ByteVisualiser::PART_COLOURS.each_with_index do |(type, color), i|
        @buffer << "\u25A0".colorize(color) << " = " << type
        @buffer << ", " unless i == ByteVisualiser::PART_COLOURS.size - 1
      end

      @buffer << ")\n"
    end

    # Adds details about the encoded value bits in the character to the buffer.
    def value_details(character)
      color = ByteVisualiser::PART_COLOURS[:value]
      value_bits = character.value_bits
      value_decimal = value_bits.to_i(2) # equivalent of character.value.codepoints.first
      value_hex = value_decimal.to_s(16).upcase

      @buffer << " Bits: " << value_bits.colorize(color) << "\n"
      @buffer << " Decimal: " << value_decimal << "\n"
      @buffer << " Hex: " << value_hex << "\n"
      @buffer << " Code Point: U+" << value_hex << "\n"
      @buffer << " Information: " << "http://codepoints.net/U+#{value_hex}" << "\n"
    end
  end
end