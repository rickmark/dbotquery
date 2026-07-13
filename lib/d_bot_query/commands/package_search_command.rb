# frozen_string_literal: true

module DBotQuery
  module Commands
    # # Package Search
    # One question we often get asked is `do we use an X library?`. This subcommand will help us
    # answer that. The subcommand should take a package name, and the result should contain a list
    # of all the repositories where that package was seen.
    #
    # ## Inputs
    #
    # | Command Line Flag | Required? | Description | Example |
    # | :--- | :--- | :--- | :--- |
    # | -f/--file | yes | Path to JSON file exported from Dependabot | dependabot.json |
    # | --package | yes | A package name | sinatra, puma, node-forge |
    #
    # ## Example commands
    # * `./dbotquery package_search -f dependabot.json --package sinatra`
    # * `./dbotquery package_search -f dependabot.json --package node-forge`
    #
    # ## Outputs
    # ```json
    # ["org/repo", "org/repo2"]
    # ```
    class PackageSearchCommand < CommandBase
      attr_reader :package

      # @param [String] package The name of the package to search for
      def initialize(package:)
        super()

        @package = package
      end

      def perform(input)
        where_package(input).map { |finding| finding[:repository][:full_name] }.uniq
      end

      private

      def where_package(input)
        input.select do |finding|
          finding[:dependency][:package][:name] == @package
        end
      end
    end
  end
end
