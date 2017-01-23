require 'rubygems'
require 'minitest/autorun'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'tuple'

if not [].respond_to?(:shuffle)
  class Array
    def shuffle
      t_self = self.dup 
      t_size = self.size 
      result=[] 
      t_size.times { result << t_self.slice!(rand(t_self.size)) } 
      result 
    end
  end
end

Minitest::Test.singleton_class.class_eval do
  def should(test_name,&block)
    define_method("test_: #{name.sub(/Test\Z/,'')} should #{test_name}. ",&block)
  end
end

module TupleTestHelper
  if defined?(Tuple::Binary)
    require 'tuple/ruby/tuple'
    module Binary
      extend Tuple::Binary
    end
    def tuple_load_binary(dump)
      Binary.load(dump)
    end
    def tuple_dump_binary(tuple)
      Binary.dump(tuple)
    end
  end

  module Ruby
    extend Tuple::Ruby
  end
  def tuple_load_ruby(dump)
    Ruby.load(dump)
  end
  def tuple_dump_ruby(tuple)
    Ruby.dump(tuple)
  end
end
