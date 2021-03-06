require_relative 'lib/pix/version'

Gem::Specification.new do |spec|
  spec.name          = 'pix'
  spec.version       = Pix::VERSION
  spec.authors       = ['wilfison']
  spec.email         = ['wilfisonbatista@gmail.com']

  spec.summary       = 'Abstração Ruby para API PIX (Pagamento Instantâneo Brasileiro)'
  spec.homepage      = 'https://github.com/Wilfison/pix'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'solargraph'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'yard'
end
