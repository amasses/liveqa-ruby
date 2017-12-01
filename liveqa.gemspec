lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liveqa/version'
require 'liveqa/library_name'

Gem::Specification.new do |s|
  s.name          = LiveQA::LIBRARY_NAME
  s.version       = LiveQA::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['LiveQA']
  s.email         = ['support@liveqa.io']
  s.homepage      = 'https://github.com/arkes/liveqa-ruby'
  s.summary       = 'LiveQA ruby integration'
  s.description   = 'LiveQA ruby integration'

  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.add_development_dependency 'faker', '~> 1.8.4'
  s.add_development_dependency 'rake', '>= 0.9.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rubocop', '= 0.49.1'
end
