# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = %q{tuple}
  s.version = '0.3.0'

  s.authors = [%q{Justin Balthrop}, %q{Ash Moran}, %q{topac}, %q{Jörg Schray}]
  s.description = %q{Fast, binary-sortable serialization for arrays of simple Ruby types.}
  s.email = %q{code@justinbalthrop.com}
  s.extensions = [%q{ext/extconf.rb}]

  s.extra_rdoc_files = %w{LICENSE README.rdoc}
  s.files         = `git ls-files`.split("\n") - s.extra_rdoc_files
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w{ext}

  s.homepage = %q{http://github.com/ninjudd/tuple}
  s.require_paths = [%q{ext}]

  s.summary = %q{Tuple serialization functions.}

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
end
