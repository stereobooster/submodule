# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "submodule/version"

Gem::Specification.new do |s|
  s.name        = "submodule"
  s.version     = Submodule::VERSION
  s.authors     = ["stereobooster"]
  s.email       = ["stereobooster@gmail.com"]
  s.homepage    = "https://github.com/stereobooster/submodule"
  s.summary     = %q{Small gem to simplify building process of gems with git submodules}
  s.description = %q{Small gem to simplify building process of gems with git submodules. Tended to be used for ruby gems which wrap js libraries or another assets}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
 
  s.add_dependency "rake"
  s.add_dependency "inifile", "~> 1.1.0"
end
