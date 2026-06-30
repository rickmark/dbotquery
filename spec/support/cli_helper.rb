# frozen_string_literal: true
# rbs_inline: enabled

module Helpers
  module CLIHelper
    attr_reader :cli

    def input_file
      File.join(File.dirname(__FILE__), '..', 'fixtures', 'dependabot.json')
    end

    def run_cli(*args)
      @result = described_class.start([*args])
    end

    def result
      @result
    end
  end
end

RSpec.configure do |c|
  c.include Helpers::CLIHelper, type: :cli
end
