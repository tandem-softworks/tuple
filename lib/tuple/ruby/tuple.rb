module Tuple
  module Ruby
    def dump(tuple)
      case tuple
      when Array
        tuple.map(&method(:dump_element)).join
      else
        dump_element(tuple)
      end
    end

    NilHeader = [0,0,0,0].pack("CCCC")
    FalseHeader = [0,0,1,0].pack("CCCC")
    TrueHeader = [0,0,255,0].pack("CCCC")
    PositiveIntegerHeader = [0,0,16].pack("CCC")
    NegativeIntegerHeader = [0,0,8].pack("CCC")
    StringHeader = [0,0,32,0].pack("CCCC")
    SymbolHeader = [0,0,64,0].pack("CCCC")
    DateTimeHeader = [0,0,128,0].pack("CCCC")
    ArrayHeader = [0,0,192,0].pack("CCCC")
    ArrayEnd = [0,0,191,0].pack("CCCC")

    def dump_element(element)
      case element
      when NilClass
        NilHeader
      when FalseClass
        FalseHeader
      when TrueClass
        TrueHeader
      when Integer
        if element >= 0
          if element == 0
            words = [0]
          elsif element > 0
            words = []
            while element > 0
              words.unshift(element.modulo(2**32))
              element = element >> 32
            end
          end
          PositiveIntegerHeader + [words.size,*words].pack("C"+ ("L>"*words.size))
        else
          words = []
          while element < 0
            words.unshift((element-1).modulo(-2**32))
            element = -(-element >> 32)
          end
          NegativeIntegerHeader + [-words.size-1,*words].pack("C"+ ("L>"*words.size))
        end
      when String
        StringHeader + pad_string(element)
      when Symbol
        SymbolHeader + pad_string(element.to_s)
      when Time
        DateTimeHeader + pad_string(element.getgm.strftime("%Y-%m-%d %H:%M:%S +0000"))
      when Date
        DateTimeHeader + pad_string(element.strftime("%Y-%m-%d"))
      when Array
        ArrayHeader + dump(element) + ArrayEnd
      else
        raise(TypeError,"invalid type %s in tuple" % element.class.name)
      end
    end

    def pad_string(string)
      padding_size = (-string.bytesize).modulo(4)
      string.dup.force_encoding('binary') + ("\x00" * padding_size)
    end

    def load(dump)
      load_array(dump + ArrayEnd)[0]
    end

    def load_array(dump)
      result = []
      rest_dump = dump
      while rest_dump.byteslice(0,4) != ArrayEnd do
        element, rest_dump = *parse_element(rest_dump)
        result << element
      end
      [result,rest_dump.byteslice(4..-1)]
    end

    def parse_element(dump)
      header,rest_dump = dump.unpack("a4a*")
      case header
      when NilHeader
        [nil,rest_dump]
      when FalseHeader
        [false,rest_dump]
      when TrueHeader
        [true,rest_dump]
      when DateTimeHeader
        if rest_dump.byteslice(10,1) == "\x00"
          [Date.parse(rest_dump.byteslice(0,10)),rest_dump.byteslice(12..-1)]
        else
          [Time.parse(rest_dump.byteslice(0,25)),rest_dump.byteslice(28..-1)]
        end
      when StringHeader, SymbolHeader
        result = "".encode('binary')
        while rest_dump.bytesize > 0 and rest_dump.byteslice(0,1) != "\x00"
          result += rest_dump.slice(0,4)
          rest_dump = rest_dump.slice(4..-1)
        end
        result.sub!(/\x00+\Z/,'')
        [header == StringHeader ? result : result.to_sym,rest_dump]
      when ArrayHeader
        load_array(rest_dump)
      else
        integer_header,word_size = header.unpack("a3c")
        case integer_header
        when PositiveIntegerHeader
          result = 0
          while word_size > 0
            current_word,rest_dump = rest_dump.unpack("L>a*")
            result = (result << 32) + current_word
            word_size -= 1
          end
          [result,rest_dump]
        when NegativeIntegerHeader
          result = 1
          while word_size < -1
            current_word,rest_dump = rest_dump.unpack("L>a*")
            result = (result << 32) - current_word
            word_size += 1
          end
          result = 1-result
        end
        [result,rest_dump]
      end
    end
  end
end
