# frozen_string_literal: true
# rbs_inline: enabled

RSpec.describe DBotQuery::Commands::CommandBase do
  it 'raises when attempting to create an instance' do
    expect { described_class.new }.to raise_error(NotImplementedError)
  end
end
