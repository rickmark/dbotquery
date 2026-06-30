# frozen_string_literal: true
# rbs_inline: enabled

module DBotQuery
  module Commands
    # # Service Level Agreement Stats
    # As part of our vulnerability management program, we need to be able to understand how many
    # open vulnerabilities there are, as well as how long they’ve been open for. For each severity, we
    # have a “service level agreement” (SLA) that states the maximum acceptable time for a
    # vulnerability is allowed to remain unresolved.
    #
    # The SLA for each severity is as follows:
    #
    # * Low: 60 Days
    # * Medium: 30 Days
    # * High: 15 Days
    # * Critical: 5 Days
    #
    # For this subcommand, we should output the number of vulnerabilities that have been open
    # longer than the SLA allows for, separated by severity.
    # ## Inputs
    #
    # ### Example commands
    # * ./your_program sla_stats -f dependabot.json
    # ○ A count of all findings that exceed the SLA, separated by severity. The current
    # time is used when calculating age.
    # ● ./your
    # _program sla
    # _
    # stats -f dependabot.json -t 2023-01-01T00:00:00Z
    # ○ A count of all findings that exceed the SLA, separated by severity. The time
    # specified is used when calculating age.
    # ### Outputs
    # ```json
    # {
    # "low": $count,
    # "medium": $count,
    # "high": $count,
    # "critical": $count,
    # "total": $count
    # }
    # ```
    # Where “$count” represents the number of findings that exceed the SLA for each severity.
    class SLAStatisticsCommand < CommandBase
    end
  end
end
