# frozen_string_literal: true

RSpec.describe DBotQuery::Commands::SLAStatisticsCommand, type: :command do
  let(:fixed_date) { Time.utc(2023, 1, 1, 0, 0, 0) }
  let(:later_date) { Time.utc(2024, 1, 1, 0, 0, 0) }

  before do
    allow(Time).to receive(:now).and_return(later_date)
  end

  describe 'current time' do
    it 'returns valid results for NOW' do
      command = described_class.new(time: nil)
      command.execute!(input_file)

      expect(command.result).not_to be_nil
    end

    it 'contains valid results for NOW' do
      command = described_class.new(time: nil)
      command.execute!(input_file)

      expect(command.result).to eq({ low: 11, medium: 33, high: 50, critical: 13, total: 107 })
    end
  end

  describe "for '2023-01-01T00:00:00Z'" do
    it 'returns a valid value' do
      command = described_class.new(time: fixed_date)
      command.execute!(input_file)

      expect(command.result).to eq({ low: 10, medium: 27, high: 45, critical: 13, total: 95 })
    end
  end

  describe 'for different dates' do
    it 'differs' do
      command_then = described_class.new(time: fixed_date)
      command_then.execute!(input_file)

      command_later = described_class.new(time: later_date)
      command_later.execute!(input_file)

      expect(command_then.result).not_to eq(command_later.result)
    end
  end
end
