# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tire-contrib/version"

Gem::Specification.new do |s|
  s.name        = "tire-contrib"
  s.version     = Tire::Contrib::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karel Minarik", "Oliver Eilhard"]
  s.email       = ["karmi@karmi.cz", "oliver.eilhard@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Contributions and additions for the Tire gem}

  s.rubyforge_project = "tire-contrib"

  s.add_dependency "tire"

  s.add_development_dependency "bundler", "~> 1.1.0"
  s.add_development_dependency "turn"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "activesupport"
  s.add_development_dependency "sqlite3"

  s.extra_rdoc_files  = [ "README.markdown", "MIT-LICENSE" ]
  s.rdoc_options      = [ "--charset=UTF-8" ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
