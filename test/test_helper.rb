require 'rubygems'
require 'minitest/autorun'
require 'shoulda'
require 'mocha/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../ext')
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
