require './lib/bitfex/version'

Gem::Specification.new do |s|
  s.name                  = 'bitfex'
  s.version               = Bitfex::VERSION
  s.date                  = '2018-03-09'
  s.description           = 'API wrapper for BitFex.Trade cryptocurrency stock exchange'
  s.summary               = 'API wrapper for BitFex.Trade'
  s.authors               = ['BitFex.Trade']
  s.email                 = 'support@bitfex.trade'
  s.files                 = `git ls-files -z`.split("\0")
  s.test_files            = `git ls-files -z test/`.split("\0")
  s.homepage              = 'https://bitfex.trade'
  s.extra_rdoc_files      = ['README.md']
  s.license               = 'MIT'
  s.required_ruby_version = '>= 2.0.0'

  s.add_development_dependency('webmock', '~> 2.0')
  s.add_development_dependency('minitest', '~> 5.11')
end
