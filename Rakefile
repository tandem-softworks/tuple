# -*- mode: ruby; encoding: utf-8 -*-
require "bundler/gem_tasks"
require "rake/extensiontask"
require 'rake/testtask'
require 'rdoc/task'

Rake::ExtensionTask.new('tuple') do |ext|
  ext.lib_dir = "lib/tuple/binary"
end

Rake::TestTask.new do |t|
  t.libs << "ext" << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = false
end

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

task :default => :test
