# frozen_string_literal: true
# rbs_inline: enabled

require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'steep/rake_task'
require 'gemika/tasks'
require 'reek/rake/task'
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

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
  t.source_files = FileList['lib/**/*.rb']
end

task default: %i[yard rubocop spec steep]
