# frozen_string_literal: true
# rbs_inline: enabled

module DBotQuery
  module Commands
    # # Summary
    #
    # This subcommand takes a JSON export from Dependabot and returns the number of findings in
    # the file. This command should take an optional “state” parameter so that the only vulnerabilities
    # that are counted are the ones that match its value (e.g. open, fixed, dismissed)
    #
    # ## Inputs
    #
    # ## Example commands
    #
    # * `./your_program summary -f dependabot.json`
    # ** Count of all findings in dependabot.json
    # * `./your_program summary -f dependabot.json --state dismissed`
    # ** Count of all dismissed findings in dependabot.json
    # * `./your_program summary -f dependabot.json --state open --severity critical`
    # ** Count of all open critical vulnerabilities
    #
    # ## Outputs
    #
    # ```json
    # {“count”: $count}
    # ```
    #
    # Where `$count` represents the count of findings in the JSON file. If --state or --severity are specified,
    # the count should only include the findings whose
    class SummaryCommand < CommandBase
      attr_reader :state, :severity

      def initialize(state: nil, severity: nil)
        super()
        @state = state
        @severity = severity
      end

      def perform(input)
        findings = input
        findings = findings.select { |finding| finding[:state]&.to_sym == @state } if @state
        if @severity
          findings = findings.select do |finding|
            finding[:security_advisory][:severity]&.to_sym == @severity
          end
        end

        {
          count: findings.count
        }
      end
    end
  end
end
