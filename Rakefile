# -*- mode: ruby; encoding: utf-8 -*-
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new do |t|
  t.libs << "ext" << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
end
task test: 'ext/tuple.so'

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'tuple'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
end

file "ext/Makefile" do
  Dir.chdir('ext') { ruby('extconf.rb') }
end

file "ext/tuple.so" => "ext/Makefile" do
  Dir.chdir('ext') { sh("make") }
end

desc "Clean"
task :clean do
  Dir.chdir('ext') { rm_f(%w{Makefile tuple.o tuple.so}) }
end

task :default => :test
