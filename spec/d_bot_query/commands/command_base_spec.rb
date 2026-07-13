# frozen_string_literal: true
# rbs_inline: enabled

require 'tempfile'

class DerivedCommand < DBotQuery::Commands::CommandBase
end

class EchoCommand < DBotQuery::Commands::CommandBase
  def perform(input)
    input
  end
end

RSpec.describe DBotQuery::Commands::CommandBase, type: :command do
  it 'raises when attempting to create an instance' do
    expect { described_class.new }.to raise_error(NotImplementedError)
  end

  describe DerivedCommand do
    it 'raises if perform is not overrode' do
      expect { described_class.new.perform(input_file) }.to raise_error(NotImplementedError)
    end
  end

  describe 'execute!' do
    def using_input(input, &)
      Tempfile.create(['dbotquery', '.json']) do |file|
        file.write(input)
        file.flush

        yield file.path
      end
    end

    it 'raises a friendly error for invalid JSON' do
      using_input('{not valid json') do |path|
        command = EchoCommand.new

        expect { command.execute!(path) }.to raise_error(DBotQuery::Error, /not valid JSON/)
      end
    end

    it 'raises a friendly error when the top-level JSON is not an array' do
      using_input('{"hello":"world"}') do |path|
        command = EchoCommand.new

        expect { command.execute!(path) }.to raise_error(JSON::Schema::ValidationError)
      end
    end
  end
end
