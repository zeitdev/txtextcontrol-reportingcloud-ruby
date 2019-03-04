# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'txtextcontrol/reportingcloud/version'

Gem::Specification.new do |spec|
  spec.name          = "txtextcontrol-reportingcloud"
  spec.version       = TXTextControl::ReportingCloud::VERSION
  spec.authors       = ["Thorsten Kummerow"]
  spec.email         = ["thorsten@textcontrol.com"]

  spec.summary       = "ReportingCloud Ruby SDK"
  spec.description   = "Official Ruby SDK for the ReportingCloud Web API. Authored and supported by Text Control GmbH."
  spec.homepage      = "http://www.reporting.cloud"
  spec.licenses      = ["BSD-2-Clause"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
