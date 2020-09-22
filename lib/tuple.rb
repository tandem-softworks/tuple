require 'tuple.so'
module Tuple
  begin
    include Binary
    module_function(:dump,:load)
  rescue NameError
    require 'tuple/ruby/tuple'
    extend Ruby
  end
end
