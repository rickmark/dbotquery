# frozen_string_literal: true
# rbs_inline: enabled

require 'json'
require 'thor'
require 'time'
require 'date'
require 'uri'
require 'json-schema'
require_relative 'd_bot_query/version'

# # Dependabot Data Viewer
#
# ## Assignment
#
# Dependabot is GitHub’s product for surfacing information about vulnerable dependencies.
# GitHub maintains a database of known vulnerabilities mapped to specific versions of specific
# dependencies, and Dependabot compares this to your package manifest (`package.json`,
# `Gemfile.lock`, etc.).
#
# GitHub makes this data available in the web interface, but we want to send this data to be
# processed elsewhere so non-engineers who don’t have access to GitHub can also see our
# vulnerabilities. To do this, we want you to write a command line utility that takes an exported
# JSON file from Dependabot and prints out some basic reports, also in JSON format. The
# command line tool will not need to talk to GitHub directly. All it needs to do is take the
# exported Dependabot JSON file as input, some configuration options, and return a JSON
# document. Please feel free to consult GitHub’s documentation on this file.
#
module DBotQuery
  # This is a generic wrapper error for those error types raised specifically by this gem.
  class Error < StandardError; end

  SCHEMA_PATH = File.join(File.dirname(__FILE__), 'schema.json')

  autoload :CLI, 'd_bot_query/cli'

  SLA_DEFINITION = {
    low: 60,
    medium: 30,
    high: 15,
    critical: 5
  }.freeze

  # Module that contains the abstract base class for all commands, as well as the implementations.  These
  # are separated in this way to allow for easier testing and maintenance.
  module Commands
    autoload :CommandBase, 'd_bot_query/commands/command_base'
    autoload :PackageSearchCommand, 'd_bot_query/commands/package_search_command'
    autoload :SummaryCommand, 'd_bot_query/commands/summary_command'
    autoload :RepoSLAStatisticsCommand, 'd_bot_query/commands/repo_sla_statistics_command'
    autoload :SLAStatisticsCommand, 'd_bot_query/commands/sla_statistics_command'
  end

  def self.schema
    @schema ||= JSON.parse(File.read(SCHEMA_PATH))
  end
end
