# frozen_string_literal: true
# rbs_inline: enabled

class DerivedCommand < DBotQuery::Commands::CommandBase
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
end
