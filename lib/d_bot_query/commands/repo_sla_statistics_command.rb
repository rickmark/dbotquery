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
    end
  end
end
