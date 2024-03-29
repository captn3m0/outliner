lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "outliner/version"

Gem::Specification.new do |spec|
  spec.name          = "outliner"
  spec.version       = Outliner::VERSION
  spec.authors       = ["Nemo"]
  spec.email         = ["outliner@captnemo.in"]
  spec.licenses      = ["MIT"]

  spec.summary       = "A simple HTTParty based client for outline knowledge base."
  spec.homepage      = "https://github.com/captn3m0/outliner"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/captn3m0/outliner"
  spec.metadata["changelog_uri"] = "https://github.com/captn3m0/outliner/blob/master/CHANGELOG.md"

  spec.files         = Dir['**/*'].reject { |f| f.match(%r{^(vendor|test|spec|features)/}) }

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21"
  spec.add_dependency "json", "~> 2.7"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_dependency "rake", ">= 13.1"
  spec.add_development_dependency "webmock", "~> 3.23"
  spec.add_development_dependency "minitest", "~> 5.22"
end
