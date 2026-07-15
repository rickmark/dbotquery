# frozen_string_literal: true
# rbs_inline: enabled

require_relative 'lib/d_bot_query/version'

Gem::Specification.new do |spec|
  spec.name = 'dbotquery'
  spec.version = DBotQuery::VERSION
  spec.authors = ['Rick Mark']
  spec.email = ['rickmark@outlook.com']

  spec.summary = 'Command-line reports for Dependabot exports'
  spec.description = 'DBotQuery reads Dependabot JSON exports and produces summary, SLA, and package search reports.'
  spec.homepage = 'https://github.com/rickmark/dbotquery'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Uncomment the line below to require MFA for gem pushes.
  # This helps protect your gem from supply chain attacks by ensuring
  # no one can publish a new version without multi-factor authentication.
  # See: https://guides.rubygems.org/mfa-requirement-opt-in/
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'activemodel', '>= 8.0'
  spec.add_dependency 'addressable'
  spec.add_dependency 'json-schema', '~> 5.0'
  spec.add_dependency 'octokit'
  spec.add_dependency 'thor', '~> 1.5'

  # For more information and examples about making a new gem, check out our
  # guide at: https://guides.rubygems.org/make-your-own-gem/
end
