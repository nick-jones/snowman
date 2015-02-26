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

    protected

    def header(character)
      @buffer << ' Character: ' << character.value << $/
    end

    def basic_details(character)
      @buffer << ' Bytes: ' << character.size << $/
      @buffer << ' Hex: ' << character.bytes.map{ |byte| byte.value.to_s(16).upcase }.join(' ') << $/
      @buffer << ' ASCII compatible: ' << (character.ascii_compatible? ? 'yes' : 'no') << $/
      @buffer << ' Plane: ' << PLANE_DESCRIPTIONS[character.plane] << $/
    end

    def byte_details(byte)
      # Extra indentation is required
      byte.to_s.lines.each do |line|
        @buffer << '  ' << line
      end
    end

    def byte_color_details
      @buffer << ' (bit colorings: '

      ByteVisualiser::PART_COLOURS.each_with_index do |(type, color), i|
        @buffer << '■'.colorize(color) << ' = ' << type
        @buffer << ', ' unless i == ByteVisualiser::PART_COLOURS.size - 1
      end

      @buffer << ')' << $/
    end

    def value_details(character)
      color = ByteVisualiser::PART_COLOURS[:value]
      value_binary = extract_value_bits(character.bytes)
      value_decimal = character.codepoint
      value_hex = value_decimal.to_s(16).upcase
      value_codepoint = "U+#{value_hex}"

      @buffer << ' Binary: ' << value_binary.colorize(color) << $/
      @buffer << ' Decimal: ' << value_decimal << $/
      @buffer << ' Hex: 0x' << value_hex << $/
      @buffer << ' Codepoint: ' << value_codepoint << $/
      @buffer << ' Details: ' << "http://codepoints.net/#{value_codepoint}" << $/
    end

    # This ensures '0' padding is retained from the values. If we used character.codepoint.to_s(2),
    # this would be lost. Given we render the value portions for each byte in full, hopefully it is
    # clearer if padding is retained.
    def extract_value_bits(bytes)
      bits = bytes.map do |byte|
        pad = 7 - byte.high_order_bits
        byte.value_portion.to_s(2).rjust(pad, '0')
      end

      bits.join('')
    end
  end
end