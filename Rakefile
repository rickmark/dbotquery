# frozen_string_literal: true
# rbs_inline: enabled

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'steep/rake_task'
require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb'] # Source files to document
  t.options = %w[--any --extra-opts]
end

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

Steep::RakeTask.new do |t|
  t.check.severity_level = :error
  t.watch.verbose = true
end

task default: %i[yard rubocop:autocorrect spec steep]
