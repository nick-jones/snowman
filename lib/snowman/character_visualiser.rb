require 'stringio'
require 'colorize'

module Snowman
  class CharacterVisualiser
    PLANE_DESCRIPTIONS = {
        :bmp => 'Basic Multilingual',
        :smp => 'Supplementary Multilingual',
        :sip => 'Supplementary Ideographic',
        :ssp => 'Supplementary Special-purpose',
        :pua => 'Private Use Area'
    }

    # Builds a string based representation of the supplied character, containing relevant information.
    def build(character)
      @buffer = StringIO.new

      @buffer << 'Supplied'.cyan.bold << $/
      header(character)
      @buffer << $/

      @buffer << 'Details'.cyan.bold << $/
      basic_details(character)
      @buffer << $/

      @buffer << 'Breakdown'.cyan.bold << $/
      byte_color_details
      @buffer << $/

      character.bytes.each_with_index do |byte, i|
        @buffer << " Byte #{(i+1).to_s}".blue.bold << $/
        byte_details(byte)
      end

      @buffer << 'Value'.cyan.bold << $/
      value_details(character)

      @buffer.string
    end

    # Adds information about the value to the buffer.
    def header(character)
      @buffer << ' Character: ' << character.value << $/
    end

    # Adds basic details about the character to the buffer.
    def basic_details(character)
      @buffer << ' Bytes: ' << character.size << $/
      @buffer << ' Hex: ' << character.bytes.map{ |byte| byte.value.to_s(16) }.join(' ').upcase << $/
      @buffer << ' ASCII compatible: ' << character.ascii_compatible? << $/
      @buffer << ' Plane: ' << PLANE_DESCRIPTIONS[character.plane] << $/
    end

    # Builds information about the supplied byte.
    def byte_details(byte)
      # Extra indentation is required
      byte.to_s.lines.each do |line|
        @buffer << '  ' << line
      end
    end

    # A basic helper key for the various colours used.
    def byte_color_details
      @buffer << ' (bit colorings: '

      ByteVisualiser::PART_COLOURS.each_with_index do |(type, color), i|
        @buffer << '■'.colorize(color) << ' = ' << type
        @buffer << ', ' unless i == ByteVisualiser::PART_COLOURS.size - 1
      end

      @buffer << ')' << $/
    end

    # Adds details about the encoded value bits in the character to the buffer.
    def value_details(character)
      color = ByteVisualiser::PART_COLOURS[:value]
      value_bits = character.value_bits
      value_decimal = value_bits.to_i(2) # equivalent of character.value.codepoints.first
      value_hex = value_decimal.to_s(16).upcase

      @buffer << ' Bits: ' << value_bits.colorize(color) << $/
      @buffer << ' Decimal: ' << value_decimal << $/
      @buffer << ' Hex: ' << value_hex << $/
      @buffer << ' Codepoint: U+' << value_hex << $/
      @buffer << ' Information: ' << "http://codepoints.net/U+#{value_hex}" << $/
    end
  end
end