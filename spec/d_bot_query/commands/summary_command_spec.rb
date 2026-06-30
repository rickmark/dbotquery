# frozen_string_literal: true

RSpec.describe DBotQuery::Commands::SummaryCommand, type: :command do
  it 'works without specifiers' do
    command = described_class.new(state: nil, severity: nil)
    command.execute!(input_file)

    expect(command.result).to eq({
                                   count: 120
                                 })
  end

  it 'works with state specifiers' do
    command = described_class.new(state: :fixed, severity: nil)
    command.execute!(input_file)

    expect(command.result).to eq({
                                   count: 101
                                 })
  end

  it 'works with severity specifiers' do
    command = described_class.new(state: nil, severity: :high)
    command.execute!(input_file)

    expect(command.result).to eq({
                                   count: 54
                                 })
  end

  it 'works with both specifiers specifiers' do
    command = described_class.new(state: :open, severity: :high)
    command.execute!(input_file)

    expect(command.result).to eq({
                                   count: 8
                                 })
  end
end
