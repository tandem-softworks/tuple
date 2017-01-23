# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = %q{tuple}
  s.version = '1.0.0'

  s.authors = [%q{Justin Balthrop}, %q{Ash Moran}, %q{topac}, %q{Jörg Schray}]
  s.description = %q{Fast (for RUBY_VERSION < 2.3), binary-sortable serialization for arrays of simple Ruby types. Pure ruby implementation for RUBY_VERSION >= 2.3.}
  s.email = %q{code@tandem-softworks.de}
  s.extensions = %w{ext/tuple/extconf.rb}

  s.extra_rdoc_files = %w{LICENSE README.rdoc}
  s.files         = `git ls-files`.split("\n") - s.extra_rdoc_files
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.homepage = %q{http://github.com/tandem-softworks/tuple}

  s.summary = %q{Tuple serialization functions.}

  s.add_development_dependency "rake"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "minitest"
end
