# frozen_string_literal: true

module DBotQuery
  # Implements the CLI parsing and argument passing.  This permits two things:
  #
  # * The separation of the command and its unit tests from the actual command line
  # * The testing of the command line interface, independent of the command itself
  class CLI < Thor
    # This ensures that Thor exits with a non-zero exit code when an error occurs
    def self.exit_on_failure?
      true
    end

    # Shared options for all commands are specified here
    class_option :file, required: true, desc: 'Path to JSON file exported from Dependabot', aliases: ['-f'],
                        example: 'dependabot.json'

    desc 'summary', 'Count the number of vulnerabilities in a Dependabot JSON file'
    long_desc <<~TEXT
      This subcommand takes a JSON export from Dependabot and returns the number of findings in
      the file. This command should take an optional “state” parameter so that the only vulnerabilities
      that are counted are the ones that match its value (e.g. open, fixed, dismissed)
    TEXT
    method_option :state, desc: 'One of the possible states a finding can have', enum: %w[open fixed dismissed]
    method_option :severity, desc: 'One of the possible severities a finding can have',
                             enum: %w[critical high medium low]
    def summary
      state = options[:state]&.to_sym       #: DBotQuery::Commands::SummaryCommand::state?
      severity = options[:severity]&.to_sym #: DBotQuery::Commands::SummaryCommand::severity?

      run! DBotQuery::Commands::SummaryCommand.new(state: state, severity: severity)
    end

    desc 'sla_stats', 'Calculate the SLA statistics for a Dependabot JSON file'
    method_option :time, desc: 'The time period to calculate the SLA statistics for', example: '2023-01-01T00:00:00Z',
                         aliases: ['-t']
    def sla_stats
      time = parse_time(options[:time])
      run! DBotQuery::Commands::SLAStatisticsCommand.new time: time
    end

    desc 'repo_sla_stats', 'Calculate the SLA statistics for a Dependabot JSON file for a given repository'
    method_option :time, desc: 'The time period to calculate the SLA statistics for', example: '2023-01-01T00:00:00Z',
                         aliases: ['-t']
    def repo_sla_stats
      time = parse_time(options[:time])
      run! DBotQuery::Commands::RepoSLAStatisticsCommand.new time: time
    end

    desc 'package_search', 'Search for a package in a Dependabot JSON file'
    option :package, desc: 'The name of the package to search for', required: true
    def package_search
      run! DBotQuery::Commands::PackageSearchCommand.new(package: options[:package])
    end

    private

    # This encapsulates the logic for running a command.  It handles all the proper console-ish things as well as
    # common parameters.
    def run!(command)
      file = options[:file]

      command.execute!(file)
    end

    def parse_time(value)
      return Time.now unless value

      Time.parse(value)
    rescue ArgumentError => e
      raise Error, "Invalid time '#{value}': #{e.message}"
    end
  end
end
