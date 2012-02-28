# -*- encoding: utf-8 -*-
require File.expand_path('../lib/trinidad_threaded_resque_extension/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carl Hörberg"]
  gem.email         = ["carl.hoerberg@gmail.com"]
  gem.description   = %q{Runs Resque workers, threaded, within the Trinidad application server}
  gem.summary       = %q{Runs Resque workers, threaded, within the Trinidad application server}
  gem.homepage      = "https://github.com/carlhoerberg/trinidad_threaded_resque_extension"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "trinidad_threaded_resque_extension"
  gem.require_paths = ["lib"]
  gem.version       = TrinidadThreadedResqueExtension::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "json"
  gem.add_runtime_dependency "trinidad"
  gem.add_runtime_dependency "resque"
end
