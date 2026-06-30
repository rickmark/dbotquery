# frozen_string_literal: true
# rbs_inline: enabled

module DBotQuery
  module Commands
    # Service Level Agreement Stats by Repo
    # Now that we can get SLA stats for the entire organization, we want to view SLA stats for specific
    # repositories as well. This will allow us to disseminate SLA statistics by repository, so the right
    # people can view information specific to their code.
    # Effectively, this will be the same thing as the previous subcommand, just broken out by
    # repository.
    # Command Line Flag Required? Description Example
    # -f/--file yes Path to JSON file exported from
    # Dependabot
    # dependabot.json
    # --time no The date/time for which the SLA
    # is being calculated, in ISO8601
    # format
    # 2023-01-01T00:00:00Z
    # Inputs
    # Example commands
    # ● ./your
    # _program repo
    # sla
    # _
    # _
    # stats -f dependabot.json
    # ○ A count of all findings that exceed the SLA, separated by severity and repository.
    # The current time is used when calculating age.
    # ● ./your
    # _program repo
    # sla
    # _
    # _
    # stats -f dependabot.json -t 2023-01-01T00:00:00Z
    # ○ A count of all findings that exceed the SLA, separated by severity and repository.
    # The time specified is used when calculating age.
    # Outputs
    # Python
    # {
    # "org/repo": { "low": $count, "medium": $count, "high": $count, "critical":
    # $count, "total": $count },
    # "org/repo2": { "low": $count, "medium": $count, "high": $count, "critical":
    # $count, "total": $count }
    # }
    # The output is roughly the same as with the previous subcommand, except broken out by
    # repository. The keys here are each individual repository, and the values are their corresponding
    # SLA stats.
    class RepoSLAStatisticsCommand < CommandBase
      def initialize(time:)
        super()
        time = Time.parse(time) if time.is_a?(String)
        @time = time || Time.now
        @date = @time.to_date
      end

      def perform(input)
        # Here we select only those which are in violation of the SLA.
        violation_map = sla_map(input).select do |finding|
          finding[:days_open] > SLA_DEFINITION[finding[:severity].to_sym]
        end

        # And finally group by the repo
        violation_map.group_by { |finding| finding[:repo] }.to_h do |repo, findings|
          sum_repo(repo, findings)
        end
      end

      private

      def sum_repo(repo, findings)
        by_level = findings.group_by { |finding| finding[:severity].to_sym }.transform_values(&:count)
        by_level = SLA_DEFINITION.to_h { |key, _| [key, 0] }.merge(by_level)
        by_level[:total] = by_level.values.sum
        [repo.to_sym, by_level]
      end

      def sla_map(input)
        # Here we build an intermediate map of findings to their SLA violations.  It will contain all vulerabilities,
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
        if finding[:fixed_at]
          (Time.parse(finding[:fixed_at]).to_date - Time.parse(finding[:created_at]).to_date).to_i
        else
          (@date - Time.parse(finding[:created_at]).to_date).to_i
        end
      end
    end
  end
end
