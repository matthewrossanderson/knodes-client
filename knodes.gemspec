# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knodes/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "knodes"
  s.rubyforge_project = s.name
  s.version     = Knodes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Anderson"]
  s.email       = ["matt@blinkapplications.com"]
  s.homepage    = "http://developers.kno.des/"
  s.summary     = %q{A ruby client library for the Knodes API}
  s.description = %q{See API documentation at http://developers.kno.des/}

   s.post_install_message =<<eos
********************************************************************************

Thanks for installing Knodes!

See API documentation at http://developers.kno.des/

There's always money in the banana stand.

********************************************************************************
eos

  s.add_development_dependency "rspec", "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end