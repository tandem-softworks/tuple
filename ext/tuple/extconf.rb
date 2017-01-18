require 'mkmf'

case RUBY_VERSION
when /\A1\.8/
  $CFLAGS += ' -DRUBY_1_8_x -DTUPLE_BINARY'
when /\A1\.9/,/\A2\.1/
  $CFLAGS += ' -DRUBY_1_9_x -DTUPLE_BINARY'
when /\A2\.2/
  $CFLAGS += ' -DRUBY_2_2_x -DTUPLE_BINARY'
when /\A2\.3/
  $CFLAGS += ' -DRUBY_2_3_x'
when /\A2\.4/
  $CFLAGS += ' -DRUBY_2_4_x'
else
  $CFLAGS += ' -DRUBY_x'
end

create_makefile('tuple')
