# frozen_string_literal: true

RSpec.describe DBotQuery::Commands::RepoSLAStatisticsCommand, type: :command do
  let(:fixed_results) do
    JSON.load_file(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'repo_stats_result.json'),
                   symbolize_names: true)
  end
  let(:fixed_date) { Time.parse('2023-01-01T00:00:00Z') }

  describe 'current time' do
    it 'returns valid results for NOW' do
      command = described_class.new(time: nil)
      command.execute!(input_file)

      expect(command.result).not_to be_nil
    end

    it 'contains valid results for NOW' do
      command = described_class.new(time: nil)
      command.execute!(input_file)

      expect(command.result).to have_key(:'dogexchange/blockchain-integration-library')
    end
  end

  describe "for '2023-01-01T00:00:00Z'" do
    it 'returns a valid value' do
      command = described_class.new(time: fixed_date)
      command.execute!(input_file)

      expect(command.result).to eq(fixed_results)
    end
  end

  describe 'for different dates' do
    it 'differs' do
      command_then = described_class.new(time: fixed_date)
      command_then.execute!(input_file)

      command_now = described_class.new(time: Time.now)
      command_now.execute!(input_file)

      expect(command_then.result).not_to eq(command_now.result)
    end
  end
end
