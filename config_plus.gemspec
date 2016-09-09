require File.expand_path('../lib/config_plus/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'config_plus'
  s.version       = ConfigPlus::VERSION
  s.summary       = 'An easy-to-use, powerful configuration module using YAML files'
  s.description   = 'ConfigPlus is an easy-to-use configuration module that uses YAML files and has powerful features such as auto mapping.'
  s.authors       = ['m4oda']
  s.email         = 'e5ww2sze@gmail.com'
  s.files         = `git ls-files lib`.split($\) + ["README.md", "README.ja.md"]
  s.homepage      = 'https://github.com/m4oda/config_plus'
  s.license       = 'MIT'

  s.required_ruby_version = '>= 2.0'
  s.add_development_dependency 'rspec', '~> 3.4'
end
