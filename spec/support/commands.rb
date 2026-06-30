# frozen_string_literal: true

module Helpers
  module CommandHelper
    def input_file
      File.join(File.dirname(__FILE__), '..', 'fixtures', 'dependabot.json')
    end

    def data
      JSON.load_file input_file
    end
  end
end

RSpec.configure do |c|
  c.include Helpers::CommandHelper, type: :command
end
