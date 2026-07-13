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
    # | Command Line Flag | Required | Description | Example |
    # |:--- | :--- | :--- | :--- |
    # | -f/--file | yes | The path to the JSON file to be processed | dependabot.json |
    # | --state | no | The state of the vulnerability to be counted | open, fixed, dismissed |
    # | --severity | no | The severity of the vulnerability to be counted | critical, high, medium, low |
    #
    # ## Example commands
    #
    # * `./your_program summary -f dependabot.json`
    #   * Count of all findings in dependabot.json
    # * `./your_program summary -f dependabot.json --state dismissed`
    #   * Count of all dismissed findings in dependabot.json
    # * `./your_program summary -f dependabot.json --state open --severity critical`
    #  * Count of all open critical vulnerabilities
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
        findings = severity_filter(state_filter(input))
        { count: findings.count }
      end

      private

      def severity_filter(input)
        @severity ? input.select { |alert| alert[:security_advisory][:severity]&.to_sym == @severity } : input
      end

      def state_filter(input)
        @state ? input.select { |alert| alert[:state]&.to_sym == @state } : input
      end
    end
  end
end
