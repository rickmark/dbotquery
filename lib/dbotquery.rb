# frozen_string_literal: true
# rbs_inline: enabled

require 'json'
require 'thor'
require 'time'
require 'date'
require 'uri'
require 'json-schema'
require 'active_model'
require 'active_support/all'
require 'addressable/template'
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

  SCHEMA = JSON.parse(File.read(SCHEMA_PATH))

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

  # Collection of models used by the DBotQuery library providing API access to data files and their contents.
  module Models
    autoload :DataFile, 'd_bot_query/models/data_file'
    autoload :Base, 'd_bot_query/models/base'
    autoload :AlertCollection, 'd_bot_query/models/alert_collection'
    autoload :Alert, 'd_bot_query/models/alert'
    autoload :Dependency, 'd_bot_query/models/dependency'
    autoload :Package, 'd_bot_query/models/package'
    autoload :Repository, 'd_bot_query/models/repository'
    autoload :SecurityAdvisory, 'd_bot_query/models/security_advisory'
    autoload :SecurityVulnerability, 'd_bot_query/models/security_vulnerability'
    autoload :VulnerabilityIdentifier, 'd_bot_query/models/vulnerability_identifier'
    autoload :Reference, 'd_bot_query/models/reference'
    autoload :CVSS, 'd_bot_query/models/cvss'
    autoload :CWE, 'd_bot_query/models/cwe'
  end

  require 'd_bot_query/octokit'

  def self.schema
    SCHEMA
  end
end
