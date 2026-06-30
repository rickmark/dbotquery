# frozen_string_literal: true
# rbs_inline: enabled

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib'
end

target :test do
  unreferenced!

  signature 'sig'

  check 'spec'

  configure_code_diagnostics(D::Ruby.lenient)

  gem 'rspec'
end
