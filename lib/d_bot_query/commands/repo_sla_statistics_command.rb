# frozen_string_literal: true
# rbs_inline: enabled

module DBotQuery
  module Commands
    # # Service Level Agreement Stats by Repo
    # Now that we can get SLA stats for the entire organization, we want to view SLA stats for specific
    # repositories as well. This will allow us to disseminate SLA statistics by repository, so the right
    # people can view information specific to their code.
    # Effectively, this will be the same thing as the previous subcommand, just broken out by
    # repository.
    #
    # ## Inputs
    #
    # | Command Line Flag | Required? | Description | Example |
    # | :--- | :--- | :--- | :--- |
    # | -f/--file | yes | Path to JSON file exported from Dependabot | dependabot.json |
    # | --time | no | The date/time for which the SLA is being calculated, in ISO8601 format | 2023-01-01T00:00:00Z |
    #
    # ## Example commands
    #
    # * `./your_program repo_sla_stats -f dependabot.json`
    #   * A count of all findings that exceed the SLA, separated by severity and repository. The current time is
    # used when calculating age.
    # * `./your_program repo_sla_stats -f dependabot.json -t 2023-01-01T00:00:00Z`
    #   * A count of all findings that exceed the SLA, separated by severity and repository. The time specified is
    # used when calculating age.
    #
    # ## Outputs
    #
    # ```json
    # {
    #   "org/repo": { "low": $count, "medium": $count, "high": $count, "critical": $count, "total": $count },
    #   "org/repo2": { "low": $count, "medium": $count, "high": $count, "critical": $count, "total": $count }
    # }
    # ```
    #
    # The output is roughly the same as with the previous subcommand, except broken out by
    # repository. The keys here are each repository, and the values are their corresponding
    # SLA stats.
    class RepoSLAStatisticsCommand < CommandBase
      def initialize(time:)
        super()
        @time = time
        @time ||= Time.now
        @date = @time.to_date
      end

      def perform(input)
        # Here we select only those which are in violation of the SLA.
        violation_map = sla_map(input).select do |finding|
          severity = finding[:severity].to_sym #: DBotQuery::Commands::CommandBase::severity
          finding[:days_open] > SLA_DEFINITION[severity]
        end

        # And finally group by the repo
        violation_map.group_by { |finding| finding[:repo] }.to_h do |repo, findings|
          sum_repo(repo, findings)
        end
      end

      private

      def sum_repo(repo, findings)
        by_level = findings.group_by do |finding|
          finding[:severity].to_sym #: DBotQuery::Commands::CommandBase::severity
        end
        by_level = SLA_DEFINITION.to_h { |key, _count| [key, 0] }.merge(by_level.transform_values(&:count))

        [repo.to_sym, { **by_level, total: by_level.values.sum }]
      end

      def sla_map(input)
        # Here we build an intermediate map of findings to their SLA violations.  It will contain all vulnerabilities,
        # their severity and the number of days open.
        input.map do |finding|
          {
            repo: finding[:repository][:full_name],
            days_open: days_open(finding),
            severity: finding[:security_advisory][:severity]
          }
        end
      end

      def days_open(finding)
        create_date = Time.parse(finding[:created_at]).to_date
        if (fix_date = finding[:fixed_at])
          (Time.parse(fix_date).to_date - create_date).to_i
        else
          (@date - create_date).to_i
        end
      end
    end
  end
end
