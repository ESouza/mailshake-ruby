# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'mailshake-ruby'
  spec.version       = "0.1.0"
  spec.authors       = ['Eduardo Souza']
  spec.email         = ['eduardo@eduardosouza.com']

  spec.summary       = 'Ruby gem for Mailshake email outreach API integration'
  spec.description   = 'Ruby gem for integrating with the Mailshake email outreach API. Supports campaigns, recipients, activity tracking, leads, team members, senders, and push webhooks.'
  spec.homepage      = 'https://github.com/esouza/mailshake-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob('{lib,spec}/**/*') + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.21'
  spec.add_dependency 'base64', '>= 0'
  spec.add_dependency 'json', '~> 2.6'

  spec.add_development_dependency 'bundler', '>= 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'webmock', '~> 3.18'
end
