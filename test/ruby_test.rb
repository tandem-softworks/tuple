# coding: utf-8
# Copyright (c) 2017 Jörg Schray; Published under The MIT License, see LICENSE

require 'test_helper'

class TupleRubyTest < Minitest::Test
  include TupleTestHelper
  alias :tuple_load :tuple_load_ruby
  alias :tuple_dump :tuple_dump_ruby

  {
    nil => "\x00\x00\x00\x00",
    false => "\x00\x00\x01\x00",
    true => "\x00\x00\xFF\x00",
    0 => "\x00\x00\x10\x01\x00\x00\x00\x00",
    1 => "\x00\x00\x10\x01\x00\x00\x00\x01",
    -1 => "\x00\x00\x08\xFE\xFF\xFF\xFF\xFE",
    2**32-1 => "\x00\x00\x10\x01\xFF\xFF\xFF\xFF",
    2**32 => "\x00\x00\x10\x02\x00\x00\x00\x01\x00\x00\x00\x00",
    2**32+1 => "\x00\x00\x10\x02\x00\x00\x00\x01\x00\x00\x00\x01",
    -2**32+1 => "\x00\x00\x08\xFE\x00\x00\x00\x00",
    -2**32 => "\x00\x00\x08\xFD\xFF\xFF\xFF\xFE\xFF\xFF\xFF\xFF",
    -2**32-1 => "\x00\x00\x08\xFD\xFF\xFF\xFF\xFE\xFF\xFF\xFF\xFE",
    2**38 => "\x00\x00\x10\x02\x00\x00\x00\x40\x00\x00\x00\x00",
    -2**38 => "\x00\x00\x08\xFD\xFF\xFF\xFF\xBF\xFF\xFF\xFF\xFF",
    2**64 => "\x00\x00\x10\x03\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00",
    -2**64 => "\x00\x00\x08\xFC\xFF\xFF\xFF\xFE\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF",
    2**(32*253) => "\x00\x00\x10\xFE\x00\x00\x00\x01" + ("\x00\x00\x00\x00" * 253),
    2**(32*254) => "\x00\x00\x10\xFF\x00\x00\x00\x01" + ("\x00\x00\x00\x00" * 254),
    2**(32*255)-1 => "\x00\x00\x10\xFF" + ("\xFF\xFF\xFF\xFF" * 255), # Largest Integer compatible with format
    -2**(32*253) => "\x00\x00\x08\x01\xFF\xFF\xFF\xFE" + ("\xFF\xFF\xFF\xFF" * 253),
    -2**(32*254) => "\x00\x00\x08\x00\xFF\xFF\xFF\xFE" + ("\xFF\xFF\xFF\xFF" * 254),
    -2**(32*255)+1 => "\x00\x00\x08\x00" + ("\x00\x00\x00\x00" * 255), # Smallest Integer compatible with format

    Date.parse('2017-01-18') => "\x00\x00\x80\x002017-01-18\x00\x00",
    Time.parse('2015-12-12 08:17:23 +0000') => "\x00\x00\x80\x002015-12-12 08:17:23 +0000\x00\x00\x00",
    '' => "\x00\x00 \x00",
    'hello' => "\x00\x00 \x00hello\x00\x00\x00",
    ''.to_sym => "\x00\x00\x40\x00",
    'hellö'.force_encoding('binary').to_sym => "\x00\x00\x40\x00hell\xC3\xB6\x00\x00",
    [] => "\x00\x00\xC0\x00\x00\x00\xBF\x00",
    [nil] => "\x00\x00\xC0\x00\x00\x00\x00\x00\x00\x00\xBF\x00",
    [1, true, :foo, "foo", -1001, false, nil, [:foo, 1, 4, nil]] => "\x00\x00\xC0\x00\x00\x00\x10\x01\x00\x00\x00\x01\x00\x00\xFF\x00\x00\x00\x40\x00foo\x00\x00\x00 \x00foo\x00\x00\x00\x08\xFE\xFF\xFF\xFC\x16\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\xC0\x00\x00\x00\x40\x00foo\x00\x00\x00\x10\x01\x00\x00\x00\x01\x00\x00\x10\x01\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\xBF\x00\x00\x00\xBF\x00",
  }.each do |element,expected_dump|

    should "load and dump #{element.inspect}" do
      expected_dump_binary = expected_dump.force_encoding('binary')
      assert_equal(expected_dump_binary,tuple_dump([element]))
      assert_equal(expected_dump_binary,tuple_dump(element)) unless element.is_a?(Array)
      assert_equal([element],tuple_load(expected_dump_binary))
    end
  end

  should "raise type error for unsupported elements" do
    exception = assert_raises(TypeError) do
      tuple_dump(1.0)
    end
    assert_equal("invalid type Float in tuple",exception.message)
  end

  should "raise argument error for bignums which do not fit serialization" do
    exception = assert_raises(ArgumentError) do
      tuple_dump_ruby(2**(32*255))
    end
    assert_equal("integer too large for serialization",exception.message)

    exception = assert_raises(ArgumentError) do
      tuple_dump_ruby(-2**(32*255))
    end
    assert_equal("integer too small for serialization",exception.message)
  end
end

if defined?(Tuple::Binary)
  class TupleRubyWithBinaryTest < TupleRubyTest
    alias :tuple_load :tuple_load_binary
    alias :tuple_dump :tuple_dump_binary
  end
end
