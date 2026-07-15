# frozen_string_literal: true
# rbs_inline: enabled

require 'bundler/setup'
Bundler.setup :test

require 'dotenv'

Dotenv.load

require 'dbotquery'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random

  Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
end
